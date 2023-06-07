LinkLuaModifier( "modifier_npc_dota_hero_skywrath_mage_permanent_ability", "heroes/hero_skywrath_mage/hero_skywrath_mage", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_skywrath_mage_permanent_ability = class({})

function npc_dota_hero_skywrath_mage_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_skywrath_mage_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_skywrath_mage_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_skywrath_mage_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_skywrath_mage_permanent_ability"
end

----------------------------------------------------------------------------
modifier_npc_dota_hero_skywrath_mage_permanent_ability = class({})

function modifier_npc_dota_hero_skywrath_mage_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_skywrath_mage_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_skywrath_mage_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_skywrath_mage_permanent_ability:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_skywrath_mage_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
	return funcs
end

function modifier_npc_dota_hero_skywrath_mage_permanent_ability:OnAbilityFullyCast( params )
	if self:GetParent():PassivesDisabled() then return end
	if params.unit == self:GetParent() and not params.ability:IsItem() then 
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.dmg = self:GetAbility():GetSpecialValueFor("dmg")
		
		local damage_table 			= {}
		damage_table.attacker 		= self:GetParent()
		damage_table.ability 		= self:GetAbility()
		damage_table.damage_type 	= self:GetAbility():GetAbilityDamageType() 
		
	local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(),  self:GetParent():GetAbsOrigin(),  nil,  self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
		for _,unit in pairs(enemies) do
			if unit:IsAlive() then
				local current_health = unit:GetHealth()
				damage_table.damage	 = (current_health / 100) * self.dmg
				damage_table.victim  = unit
				ApplyDamage(damage_table)
			end
		end
	end
end