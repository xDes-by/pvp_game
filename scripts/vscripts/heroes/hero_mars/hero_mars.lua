LinkLuaModifier( "modifier_npc_dota_hero_mars_permanent_ability", "heroes/hero_mars/hero_mars", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_mars_permanent_ability = class({})

function npc_dota_hero_mars_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_mars_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_mars_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_mars_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_mars_permanent_ability"
end

-------------------------------------------------------------------------

modifier_npc_dota_hero_mars_permanent_ability = class({})

function modifier_npc_dota_hero_mars_permanent_ability:OnCreated()
	self.angle = 70
end

function modifier_npc_dota_hero_mars_permanent_ability:OnRefresh()
	self.angle = 70
end

function modifier_npc_dota_hero_mars_permanent_ability:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_npc_dota_hero_mars_permanent_ability:GetModifierIncomingPhysicalDamage_Percentage(params)
	if self:GetParent():PassivesDisabled() then return 0 end--or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return 0 end

	local forwardVector			= self:GetCaster():GetForwardVector()
	local forwardAngle			= math.deg(math.atan2(forwardVector.x, forwardVector.y))
			
	local reverseEnemyVector	= (self:GetCaster():GetAbsOrigin() - params.attacker:GetAbsOrigin()):Normalized()
	local reverseEnemyAngle		= math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

	local difference = math.abs(forwardAngle - reverseEnemyAngle)

	if (difference <= (self.angle / 2)) or (difference >= (360 - (self.angle / 2))) then
		local attacker_vector = (params.attacker:GetOrigin() - self:GetParent():GetOrigin())
		if RandomInt(1,100) <= self:GetAbility():GetSpecialValueFor("chance") then
			self:PlayEffects( true, attacker_vector )
			return -100
		end
		return 0
	end
end

function modifier_npc_dota_hero_mars_permanent_ability:PlayEffects( front )
	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_of_mars.vpcf"
	local sound_cast = "Hero_Mars.Shield.Block"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, self:GetParent() )
end