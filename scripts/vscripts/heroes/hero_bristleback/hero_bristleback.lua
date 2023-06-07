LinkLuaModifier( "modifier_npc_dota_hero_bristleback_permanent_ability", "heroes/hero_bristleback/hero_bristleback", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_incom_damage", "heroes/hero_bristleback/hero_bristleback", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_bristleback_permanent_ability = class({})

function npc_dota_hero_bristleback_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_bristleback_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_bristleback_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_bristleback_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_bristleback_permanent_ability"
end

-------------------------------------------------------------------------

modifier_npc_dota_hero_bristleback_permanent_ability = class({})

function modifier_npc_dota_hero_bristleback_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_bristleback_permanent_ability:IsStunDebuff()
	return false
end

function modifier_npc_dota_hero_bristleback_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_bristleback_permanent_ability:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	self.damage_ampl = self:GetAbility():GetSpecialValueFor("damage")
	self.angle = 90
end

function modifier_npc_dota_hero_bristleback_permanent_ability:OnRefresh()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	self.damage_ampl = self:GetAbility():GetSpecialValueFor("damage")
	self.angle = 90
end

function modifier_npc_dota_hero_bristleback_permanent_ability:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_npc_dota_hero_bristleback_permanent_ability:GetModifierIncomingDamage_Percentage(params)
	if self.parent:PassivesDisabled() then return 0 end--or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return 0 end

	local forwardVector			= self.caster:GetForwardVector()
	local forwardAngle			= math.deg(math.atan2(forwardVector.x, forwardVector.y))
			
	local reverseEnemyVector	= (self.caster:GetAbsOrigin() - params.attacker:GetAbsOrigin()):Normalized()
	local reverseEnemyAngle		= math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

	local difference = math.abs(forwardAngle - reverseEnemyAngle)

	if (difference <= (self.angle / 2)) or (difference >= (360 - (self.angle / 2))) then
		--print("Hit the back ", (self.back_damage_reduction), "%")
		return 0
	elseif (difference <= (110 / 2)) or (difference >= (360 - (110 / 2))) then 
		--print("Hit the side", (self.side_damage_reduction), "%")
		return 0
	else
		--print("Hit the front")
		return self.damage_ampl
	end
end

function modifier_npc_dota_hero_bristleback_permanent_ability:OnTakeDamage( params )
	if IsServer() then
		if params.unit == self.parent then
			if self.parent:PassivesDisabled() then return end--or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return end
					
			local forwardVector			= self.caster:GetForwardVector()
			local forwardAngle			= math.deg(math.atan2(forwardVector.x, forwardVector.y))
					
			local reverseEnemyVector	= (self.caster:GetAbsOrigin() - params.attacker:GetAbsOrigin()):Normalized()
			local reverseEnemyAngle		= math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

			local difference = math.abs(forwardAngle - reverseEnemyAngle)

			if (difference <= (self.angle / 2)) or (difference >= (360 - (self.angle / 2))) then
				local damageTable = {
					victim			= params.attacker,
					damage			= params.original_damage * self:GetAbility():GetSpecialValueFor("damage") * 0.01,
					damage_type		= params.damage_type,
					damage_flags	= DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
					attacker		= self:GetParent(),
					ability			= self:GetAbility()
				}
				ApplyDamage(damageTable)	
			elseif (difference <= (110 / 2)) or (difference >= (360 - (110 / 2))) then 
				--print("Hit the side", (self.side_damage_reduction), "%")
			else
				--print("Hit the front")
			local attacker = params.attacker	
				attacker:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_incom_damage",{ duration = 1}	)
			end
		end
	end
end

--------------------------------------------------------------------------

modifier_incom_damage = class({})

function modifier_incom_damage:IsHidden()
	return false
end

function modifier_incom_damage:IsDebuff()
	return true
end

function modifier_incom_damage:IsStunDebuff()
	return false
end

function modifier_incom_damage:IsPurgable()
	return false
end

function modifier_incom_damage:OnCreated( kv )
	self.damage_ampl = self:GetAbility():GetSpecialValueFor("damage")
end

function modifier_incom_damage:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_incom_damage:GetModifierIncomingDamage_Percentage(params)
	local attacker = params.attacker	
		if attacker == self:GetCaster() then 
			return self.damage_ampl
		end
	return 0
end