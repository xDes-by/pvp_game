LinkLuaModifier( "modifier_npc_dota_hero_abyssal_underlord_permanent_ability", "heroes/hero_abyssal_underlord/hero_abyssal_underlord", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_abyssal_underlord_permanent_ability = class({})

function npc_dota_hero_abyssal_underlord_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_abyssal_underlord_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_abyssal_underlord_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_abyssal_underlord_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_abyssal_underlord_permanent_ability"
end

---------------------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_abyssal_underlord_permanent_ability = class({})

function modifier_npc_dota_hero_abyssal_underlord_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_abyssal_underlord_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_abyssal_underlord_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_abyssal_underlord_permanent_ability:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )/5
	if IsServer() and self:GetParent():IsAlive() then	
		self.damageTable = {
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}
		self:StartIntervalThink( 0.2 )
	end
end

function modifier_npc_dota_hero_abyssal_underlord_permanent_ability:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_npc_dota_hero_abyssal_underlord_permanent_ability:OnIntervalThink()
if IsServer() and self:GetParent():IsAlive() then
	
		local enemies = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(),	-- int, your team number
			self:GetParent():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		for _,enemy in pairs(enemies) do
			if not enemy:IsMagicImmune() then
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )

			self:PlayEffects2( enemy )
			end
		end
	end
end

function modifier_npc_dota_hero_abyssal_underlord_permanent_ability:GetEffectName()
	return "particles/units/heroes/hero_doom_bringer/doom_bringer_scorched_earth_buff.vpcf"
end

function modifier_npc_dota_hero_abyssal_underlord_permanent_ability:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_npc_dota_hero_abyssal_underlord_permanent_ability:PlayEffects2( target )
	local particle_cast = "particles/units/heroes/hero_doom_bringer/doom_bringer_scorched_earth_debuff.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end