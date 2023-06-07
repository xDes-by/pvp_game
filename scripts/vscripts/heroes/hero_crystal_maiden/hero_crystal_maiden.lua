npc_dota_hero_crystal_maiden_permanent_ability = class({})

LinkLuaModifier( "modifier_npc_dota_hero_crystal_maiden_permanent_ability", "heroes/hero_crystal_maiden/hero_crystal_maiden", LUA_MODIFIER_MOTION_NONE )

function npc_dota_hero_crystal_maiden_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_crystal_maiden_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_crystal_maiden_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_crystal_maiden_permanent_ability:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_crystal_maiden_permanent_ability"
end

modifier_npc_dota_hero_crystal_maiden_permanent_ability = class({})

function modifier_npc_dota_hero_crystal_maiden_permanent_ability:IsPassive() 
	return true 
end

function modifier_npc_dota_hero_crystal_maiden_permanent_ability:IsHidden() 
	return true 
end

function modifier_npc_dota_hero_crystal_maiden_permanent_ability:IsPurgable() 
	return false 
end

function modifier_npc_dota_hero_crystal_maiden_permanent_ability:DeclareFunctions() 
    return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
    } 
end

function modifier_npc_dota_hero_crystal_maiden_permanent_ability:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor("spell_amplify")
end

function modifier_npc_dota_hero_crystal_maiden_permanent_ability:GetModifierPercentageManacost()
    return self:GetAbility():GetSpecialValueFor("manacost_reduction")
end