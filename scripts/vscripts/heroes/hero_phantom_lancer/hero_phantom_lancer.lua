npc_dota_hero_phantom_lancer_permanent_ability = class({})

LinkLuaModifier('modifier_npc_dota_hero_phantom_lancer_permanent_ability', "heroes/hero_phantom_lancer/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)

function npc_dota_hero_phantom_lancer_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_phantom_lancer_permanent_ability:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_phantom_lancer_permanent_ability"
end

modifier_npc_dota_hero_phantom_lancer_permanent_ability = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) 
        return {
            MODIFIER_PROPERTY_HEALTH_BONUS
        } 
    end,
    GetModifierHealthBonus = function(self) return self:GetAbility():GetSpecialValueFor("hp") end,
})

