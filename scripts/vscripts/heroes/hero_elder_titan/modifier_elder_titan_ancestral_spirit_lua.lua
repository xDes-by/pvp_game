modifier_elder_titan_ancestral_spirit_lua = modifier_elder_titan_ancestral_spirit_lua or class({})

-- Modifier properties
function modifier_elder_titan_ancestral_spirit_lua:IsHidden() return true end
function modifier_elder_titan_ancestral_spirit_lua:IsPurgable() return false end

function modifier_elder_titan_ancestral_spirit_lua:OnCreated()
	self.return_timer = 0.0
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.duration = self:GetAbility():GetSpecialValueFor("spirit_duration")
	self.buff_duration = self:GetAbility():GetSpecialValueFor("buff_duration")
	self.pass_damage = self:GetAbility():GetSpecialValueFor("pass_damage")
	self.damage_heroes = self:GetAbility():GetSpecialValueFor("damage_heroes") + self:GetAbility():GetCaster():FindTalentValue("special_bonus_unique_elder_titan")
	self.damage_creeps = self:GetAbility():GetSpecialValueFor("damage_creeps")
	self.speed_heroes = self:GetAbility():GetSpecialValueFor("move_pct_heroes")
	self.speed_creeps = self:GetAbility():GetSpecialValueFor("move_pct_creeps")
	self.armor_creeps = self:GetAbility():GetSpecialValueFor("armor_creeps")
	self.armor_heroes = self:GetAbility():GetSpecialValueFor("armor_heroes")
	self.scepter_magic_immune_per_hero	= self:GetAbility():GetSpecialValueFor("scepter_magic_immune_per_hero")

	self.bonus_damage = 0
	self.bonus_ms = 0
	self.bonus_armor = 0

	self.targets_hit = {}

	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.pfx, 2, Vector(self.radius, 0, 0))

	if IsServer() then
		self.real_hero_counter = 0

		EmitSoundOn("Hero_ElderTitan.AncestralSpirit.Spawn", self:GetParent())
		self:StartIntervalThink(0.1)
	end
end

function modifier_elder_titan_ancestral_spirit_lua:OnDestroy()
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
end

function modifier_elder_titan_ancestral_spirit_lua:OnIntervalThink()

	-- Stupid exception for if the hero is changed / deleted while the Astral Spirit is up; remove it
	if not (self:GetAbility() and not self:GetAbility():IsNull()) or not(self:GetParent():GetOwner() and not self:GetParent():GetOwner():IsNull()) then
		self:OnSpiritRemoval()
		return
	end
	local ability = self:GetAbility()
	local owner = self:GetParent():GetOwner()

	-- Constantly check for nearby enemies to see if they haven't been hit by Astral Spirit yet
	local nearby_enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _, enemy in pairs(nearby_enemies) do
		-- Check if this enemy was already hit
		local enemy_has_been_hit = false

		for _, enemy_hit in pairs(self.targets_hit) do
			if enemy == enemy_hit then
				enemy_has_been_hit = true
				break
			end
		end

		-- If not, blast it
		if not enemy_has_been_hit then
			-- Play hit particle
			local hit_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_touch.vpcf", PATTACH_CUSTOMORIGIN, enemy)
			ParticleManager:SetParticleControl(hit_pfx, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControlEnt(hit_pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)

			ParticleManager:ReleaseParticleIndex(hit_pfx)

			EmitSoundOn("Hero_ElderTitan.AncestralSpirit.Buff", enemy)
			ApplyDamage({attacker = self:GetParent(), victim = enemy, ability = ability, damage = self.pass_damage, damage_type = DAMAGE_TYPE_MAGICAL})

			-- Add enemy to the targets hit table
			self.targets_hit[#self.targets_hit + 1] = enemy
			if enemy:IsRealHero() then
				self.bonus_damage	= self.bonus_damage + self.damage_heroes
				self.bonus_ms		= self.bonus_ms + self.speed_heroes
				self.bonus_armor	= self.bonus_armor + self.armor_heroes

				self.real_hero_counter = self.real_hero_counter + 1
			else
				self.bonus_damage	= self.bonus_damage + self.damage_creeps
				self.bonus_ms		= self.bonus_ms + self.speed_creeps
				self.bonus_armor	= self.bonus_armor + self.armor_creeps
			end
		end
	end

	-- If Elder Titan is killed while the Astral Spirit is out, immediately swap the ability back and destroy the spirit

	if not owner:IsAlive() then
		self:OnSpiritRemoval()
		return
	end

	if not self.et_ab then self.et_ab = self:GetParent():FindAbilityByName("elder_titan_echo_stomp_spirit_lua") end
	if not self.owner_echo_stomp_ability then self.owner_echo_stomp_ability = owner:FindAbilityByName("elder_titan_echo_stomp_lua") end

	if (self.et_ab and self.return_timer > self.duration and not self.et_ab:IsInAbilityPhase() and not self:GetParent().is_returning) or (self:GetParent():GetRangeToUnit(owner) <= ability:GetSpecialValueFor("unite_radius")) then
		self:GetParent():MoveToNPC(owner)
		self:GetParent().is_returning = true
		self:SetStackCount(1)
		EmitSoundOn("Hero_ElderTitan.AncestralSpirit.Return", self:GetParent())
	end

	if self:GetParent().is_returning and (not self.owner_echo_stomp_ability or (not self.owner_echo_stomp_ability:IsInAbilityPhase() and not self.owner_echo_stomp_ability:IsChanneling())) then
		self:GetParent():MoveToNPC(owner)
	end

	if self.return_timer - 10.0 > self.duration or
	(self:GetParent().is_returning == true and (owner:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length() < 180) then
		if self.bonus_damage > 0 then
			local damage_mod = owner:AddNewModifier(owner, ability, "modifier_elder_titan_ancestral_spirit_lua_damage", {duration = self.buff_duration})
			damage_mod:SetStackCount(self.bonus_damage)
		end

		if self.bonus_ms > 0 then
			local speed_mod = owner:AddNewModifier(owner, ability, "modifier_elder_titan_ancestral_spirit_lua_ms", {duration = self.buff_duration})
			speed_mod:SetStackCount(self.bonus_ms)
		end

		if self.bonus_armor > 0 then
			local armor_mod = owner:AddNewModifier(owner, ability, "modifier_elder_titan_ancestral_spirit_lua_armor", {duration = self.buff_duration})
			armor_mod:SetStackCount(self.bonus_armor * 10)
		end

		if owner:HasScepter() then
			owner:EmitSound("DOTA_Item.BlackKingBar.Activate")
			owner:AddNewModifier(owner, ability, "modifier_elder_titan_echo_stomp_magic_immune", {duration = self.real_hero_counter * self.scepter_magic_immune_per_hero})
		end

		self:OnSpiritRemoval()
		return nil
	end

	self.return_timer = self.return_timer + 0.1
end

function modifier_elder_titan_ancestral_spirit_lua:OnSpiritRemoval()
	local owner = self:GetParent():GetOwner()

	if owner and not owner:IsNull() then
		owner:SwapAbilities("elder_titan_ancestral_spirit_lua", "elder_titan_return_spirit_lua", true, false)
		owner.astral_spirit = nil

		local move_spirit = owner:FindAbilityByName("elder_titan_move_spirit_lua")
		if move_spirit and not move_spirit:IsNull() then
			move_spirit:SetActivated(false)
		end
	end
	self:GetParent():RemoveSelf()
end

function modifier_elder_titan_ancestral_spirit_lua:CheckState()
	if IsServer() then
		local state = {}

		state = {
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_FLYING] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_COMMAND_RESTRICTED] = false
		}

		if self:GetStackCount() == 1 then
			state = {
				[MODIFIER_STATE_UNSELECTABLE] = true,
				[MODIFIER_STATE_NO_HEALTH_BAR] = true,
				[MODIFIER_STATE_FLYING] = true,
				[MODIFIER_STATE_INVULNERABLE] = true,
				[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
				[MODIFIER_STATE_COMMAND_RESTRICTED] = true
			}
		end
		return state
	end
end

function modifier_elder_titan_ancestral_spirit_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,

		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,

		MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION
	}
end

function modifier_elder_titan_ancestral_spirit_lua:GetModifierMoveSpeed_AbsoluteMin(keys)
	local ability = self:GetAbility()
	if not (ability and not ability:IsNull()) then return end

	if self:GetStackCount() == 1 then
		return ability:GetSpecialValueFor("return_speed")
	end

	return ability:GetSpecialValueFor("speed")
end

function modifier_elder_titan_ancestral_spirit_lua:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_elder_titan_ancestral_spirit_lua:GetOverrideAnimation()
	if self:GetStackCount() == 1 then
		return ACT_DOTA_FLAIL
	end
end

function modifier_elder_titan_ancestral_spirit_lua:GetOverrideAnimationRate()
	if self:GetStackCount() == 1 then
		return 0.2
	end
end

function modifier_elder_titan_ancestral_spirit_lua:GetBonusDayVision()
	return self.radius
end

function modifier_elder_titan_ancestral_spirit_lua:GetBonusNightVision()
	return self.radius
end
