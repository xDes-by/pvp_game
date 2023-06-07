LinkLuaModifier( "modifier_npc_dota_hero_wisp_permanent_ability", "heroes/hero_wisp/hero_wisp", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_wisp_permanent_ability = class({})

function npc_dota_hero_wisp_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_wisp_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_wisp_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_wisp_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_wisp_permanent_ability"
end

---------------------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_wisp_permanent_ability = class({})

function modifier_npc_dota_hero_wisp_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_wisp_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_wisp_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_wisp_permanent_ability:RemoveOnDeath()
	return false
end


function modifier_npc_dota_hero_wisp_permanent_ability:OnCreated( kv )
	self.stats = self:GetAbility():GetSpecialValueFor( "stats" )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.out_damage = self:GetAbility():GetSpecialValueFor( "out_damage" )
end

function modifier_npc_dota_hero_wisp_permanent_ability:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_npc_dota_hero_wisp_permanent_ability:OnRemoved()
end

function modifier_npc_dota_hero_wisp_permanent_ability:OnDestroy()
end

function modifier_npc_dota_hero_wisp_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

function modifier_npc_dota_hero_wisp_permanent_ability:GetModifierBonusStats_Strength()
	return self.stats 
end

function modifier_npc_dota_hero_wisp_permanent_ability:GetModifierBonusStats_Agility()
	return self.stats 
end

function modifier_npc_dota_hero_wisp_permanent_ability:GetModifierBonusStats_Intellect()
	return self.stats 
end

function modifier_npc_dota_hero_wisp_permanent_ability:GetModifierPhysicalArmorBonus()
	if self:GetAbility():GetLevel() > 1 then
		return self.armor
	end
	return 0
end

function modifier_npc_dota_hero_wisp_permanent_ability:GetModifierTotalDamageOutgoing_Percentage()
	if self:GetAbility():GetLevel() > 2 then
		return self.out_damage
	end
	return 0
end