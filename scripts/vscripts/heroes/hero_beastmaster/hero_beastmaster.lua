
LinkLuaModifier('modifier_npc_dota_hero_beastmaster_permanent_ability', "heroes/hero_beastmaster/hero_beastmaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_beastmaster_permanent_ability_crit', "heroes/hero_beastmaster/hero_beastmaster", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_beastmaster_permanent_ability = class({})

function npc_dota_hero_beastmaster_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_beastmaster_permanent_ability'
end

function npc_dota_hero_beastmaster_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

modifier_npc_dota_hero_beastmaster_permanent_ability = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    IsAura                  = function(self) return true end,
    GetAuraRadius           = function(self) return self:GetAbility():GetSpecialValueFor("range") end,
    GetAuraSearchTeam       = function(self) return DOTA_UNIT_TARGET_TEAM_FRIENDLY end,
    GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_NONE end,
    GetAuraSearchType       = function(self) return DOTA_UNIT_TARGET_ALL end,
    GetModifierAura         = function(self) return 'modifier_npc_dota_hero_beastmaster_permanent_ability_crit' end,
})

modifier_npc_dota_hero_beastmaster_permanent_ability_crit = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) 
        if not IsServer() then return end
        if self:GetParent():GetOwner() ~= nil and self:GetParent():GetOwner():GetName() == "npc_dota_hero_beastmaster" then
            return {
            MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        }
        end
     end,
    GetModifierPreAttack_CriticalStrike = function(self) 
        if not IsServer() then return end
	    if IsServer() and (not self:GetParent():PassivesDisabled()) and RandomInt(1,100) <= self:GetAbility():GetSpecialValueFor("chance") then
            return self:GetAbility():GetSpecialValueFor("crit")
        end 
     end,
})
