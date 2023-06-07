npc_dota_hero_tinker_permanent_ability = class({})

LinkLuaModifier( "modifier_npc_dota_hero_tinker_permanent_ability", "heroes/hero_tinker/hero_tinker", LUA_MODIFIER_MOTION_NONE )

function npc_dota_hero_tinker_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_tinker_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_tinker_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_tinker_permanent_ability:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_tinker_permanent_ability"
end

modifier_npc_dota_hero_tinker_permanent_ability = class({})

function modifier_npc_dota_hero_tinker_permanent_ability:IsHidden() 
	return true 
end

function modifier_npc_dota_hero_tinker_permanent_ability:IsPurgable() 
	return false 
end

function modifier_npc_dota_hero_tinker_permanent_ability:DeclareFunctions() 
    return {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
    } 
end

function modifier_npc_dota_hero_tinker_permanent_ability:GetModifierPercentageManacost()
if self:GetParent():PassivesDisabled() then return end
	return self:GetAbility():GetSpecialValueFor("cd")
end