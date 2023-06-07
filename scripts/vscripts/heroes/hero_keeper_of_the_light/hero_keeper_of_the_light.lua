LinkLuaModifier('modifier_npc_dota_hero_keeper_of_the_light_permanent_ability', "heroes/hero_keeper_of_the_light/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_keeper_of_the_light_permanent_ability = class({})

function npc_dota_hero_keeper_of_the_light_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_keeper_of_the_light_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_keeper_of_the_light_permanent_ability'
end

modifier_npc_dota_hero_keeper_of_the_light_permanent_ability = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_SOURCE,
            MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET 
        }
    end,
    GetModifierHealAmplify_PercentageSource = function(self,data) 
    if self:GetParent():PassivesDisabled() then return end
        return self:GetAbility():GetSpecialValueFor("heal")
    end,
    GetModifierHealAmplify_PercentageTarget = function(self,data) 
    if self:GetParent():PassivesDisabled() then return end
        return self:GetAbility():GetSpecialValueFor("heal")
    end,
})
