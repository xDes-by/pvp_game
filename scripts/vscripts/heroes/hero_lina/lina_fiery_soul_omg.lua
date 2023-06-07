LinkLuaModifier( "modifier_lina_fiery_soul_omg", "heroes/hero_lina/lina_fiery_soul_omg.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_fiery_soul_omg_cooldown", "heroes/hero_lina/lina_fiery_soul_omg.lua", LUA_MODIFIER_MOTION_NONE )

lina_fiery_soul_omg = class({})

function lina_fiery_soul_omg:GetIntrinsicModifierName()
	return "modifier_lina_fiery_soul_omg"
end



modifier_lina_fiery_soul_omg = class({})

function modifier_lina_fiery_soul_omg:IsHidden() return self:GetStackCount() == 0 end
function modifier_lina_fiery_soul_omg:IsPurgable() return false end
function modifier_lina_fiery_soul_omg:IsDebuff() return false end
function modifier_lina_fiery_soul_omg:DestroyOnExpire() return false end

function modifier_lina_fiery_soul_omg:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	
	-- Ability specials
	self.fiery_soul_attack_speed_bonus = self.ability:GetSpecialValueFor("fiery_soul_attack_speed_bonus")
	self.fiery_soul_move_speed_bonus = self.ability:GetSpecialValueFor("fiery_soul_move_speed_bonus")
	self.fiery_soul_max_stacks = self.ability:GetSpecialValueFor("fiery_soul_max_stacks")
	self.fiery_soul_stack_duration = self.ability:GetSpecialValueFor("fiery_soul_stack_duration")
	self.shard_spell_bonus_damage = self.ability:GetSpecialValueFor("shard_spell_bonus_damage")
	self.internal_cooldown = self.ability:GetSpecialValueFor("internal_cooldown")

	-- If talent is upgraded before spell is learned
	if self.caster:HasTalent("special_bonus_unique_lina_2") then
		self.fiery_soul_attack_speed_bonus = self.ability:GetSpecialValueFor("fiery_soul_attack_speed_bonus") + self.caster:FindTalentValue("special_bonus_unique_lina_2", "value")
		self.fiery_soul_move_speed_bonus = self.ability:GetSpecialValueFor("fiery_soul_move_speed_bonus") + self.caster:FindTalentValue("special_bonus_unique_lina_2", "value2")
	end

	-- Talent listener
	if not self.listener then
		self.listener = ListenToGameEvent(
			"dota_player_learned_ability", 
			Dynamic_Wrap(modifier_lina_fiery_soul_omg, "OnPlayerLearnedAbility"),
			self
		)	
	end
	
	-- Particles
	if not self.effect_cast then
		self.effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_fiery_soul.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl(self.effect_cast, 1, Vector( self:GetStackCount(), 0, 0 ) )
		self:AddParticle(self.effect_cast, false, false, -1, false, false )
	end
end

function modifier_lina_fiery_soul_omg:OnRefresh(keys)
	self:OnCreated(keys)
end

function modifier_lina_fiery_soul_omg:OnDestroy()
	if self.listener then
		StopListeningToGameEvent(self.listener)
	end
end

function modifier_lina_fiery_soul_omg:OnPlayerLearnedAbility( keys )
	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end
	if keys.PlayerID ~= caster:GetPlayerOwnerID() then return end
	-- if talent is upgraded after spell is learned
	if self and not self:IsNull() and self.talent and keys.abilityname == "special_bonus_unique_lina_2" then		
		self.fiery_soul_attack_speed_bonus = self:GetAbility():GetSpecialValueFor("fiery_soul_attack_speed_bonus") + self.caster:FindTalentValue("special_bonus_unique_lina_2", "value")
		self.fiery_soul_move_speed_bonus = self:GetAbility():GetSpecialValueFor("fiery_soul_move_speed_bonus") + self.caster:FindTalentValue("special_bonus_unique_lina_2", "value2")
	end
end

function modifier_lina_fiery_soul_omg:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_lina_fiery_soul_omg:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetStackCount() * (self.fiery_soul_attack_speed_bonus or 0)
end

function modifier_lina_fiery_soul_omg:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetStackCount() * (self.fiery_soul_move_speed_bonus or 0)
end

modifier_lina_fiery_soul_omg.ability_exceptions = {
	-- there will be some :)
}

function modifier_lina_fiery_soul_omg:ModifierDamageFilter(kv)
	if not self.ability or self.ability:IsNull() or not kv.ability then return 0 end
	if kv.attacker ~= self:GetParent() or kv.target:GetTeam() == self:GetParent():GetTeam() then return 0 end
	if (self.ability_exceptions and self.ability_exceptions[kv.ability:GetAbilityName()]) or kv.ability:IsItem() then return 0 end
	if self:GetParent():PassivesDisabled() then return 0 end

	-- Increment stack
	if self:GetStackCount() < self.fiery_soul_max_stacks then
		self:IncrementStackCount()
	end

	-- Refresh duration
	self:SetDuration( self.fiery_soul_stack_duration, true )
	self:StartIntervalThink( self.fiery_soul_stack_duration )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self:GetStackCount(), 0, 0 ) )

	-- Calculate added shard damage
	local damage = 0
	if kv.attacker:HasShard() then
		local cooldown_modifiers = kv.target:FindAllModifiersByName("modifier_lina_fiery_soul_omg_cooldown")
		local is_cooldown = false

		for _, modifier in pairs(cooldown_modifiers) do
			if modifier:GetAbility() and modifier:GetAbility() == kv.ability then
				is_cooldown = true
			end
		end

		if (not is_cooldown) then
			if kv.target:IsAlive() and (not kv.target:IsInvulnerable()) then
				kv.target:AddNewModifier(kv.attacker, kv.ability, "modifier_lina_fiery_soul_omg_cooldown", {duration = self.internal_cooldown or 0})
			end

			damage = self.shard_spell_bonus_damage * math.max(self:GetStackCount(), 0)
			if kv.damagetype == DAMAGE_TYPE_PHYSICAL then
				local armor = kv.target:GetPhysicalArmorValue(false)
				local physical_resistance = (0.06 * armor) / (1 + 0.06 * math.abs(armor))
				damage = damage * (1 - physical_resistance)
			elseif kv.damagetype == DAMAGE_TYPE_MAGICAL then
				damage = damage * (1 - kv.target:GetMagicalArmorValue())
			end
		end
	end

	return damage

end

function modifier_lina_fiery_soul_omg:OnIntervalThink()
	-- Expire
	if not self or self:IsNull() then return end
	self:StartIntervalThink( -1 )
	self:SetStackCount( 0 )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self:GetStackCount(), 0, 0 ) )
end



modifier_lina_fiery_soul_omg_cooldown = class({})

function modifier_lina_fiery_soul_omg_cooldown:IsHidden() return true end
function modifier_lina_fiery_soul_omg_cooldown:IsPurgable() return false end
function modifier_lina_fiery_soul_omg_cooldown:IsDebuff() return false end
function modifier_lina_fiery_soul_omg_cooldown:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
