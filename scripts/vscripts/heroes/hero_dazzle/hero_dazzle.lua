LinkLuaModifier('modifier_npc_dota_hero_dazzle_permanent_ability', "heroes/hero_dazzle/hero_dazzle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_beastmaster_permanent_ability_cd', "heroes/hero_dazzle/hero_dazzle", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_dazzle_permanent_ability = class({})

function npc_dota_hero_dazzle_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_dazzle_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_dazzle_permanent_ability'
end

modifier_npc_dota_hero_dazzle_permanent_ability = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    AllowIllusionDuplicate  = function(self) return false end,
    IsPermanent             = function(self) return true end,
    IsAura                  = function(self) return true end,
    GetAuraRadius           = function(self) return self:GetAbility():GetSpecialValueFor("range") end,
    GetAuraSearchTeam       = function(self) return DOTA_UNIT_TARGET_TEAM_ENEMY end,
    GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_NONE end,
    GetAuraSearchType       = function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end,
    GetModifierAura         = function(self) return 'modifier_npc_dota_hero_beastmaster_permanent_ability_cd' end,
})

modifier_npc_dota_hero_beastmaster_permanent_ability_cd = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) 
        return {
            MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        }
     end,
    GetModifierPercentageCooldown = function(self) 
	    if (not self:GetParent():PassivesDisabled()) then
            return self:GetAbility():GetSpecialValueFor("cd") * (-1)
        end 
     end,
})
