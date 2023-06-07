LinkLuaModifier('modifier_npc_dota_hero_necrolyte_permanent_ability', "heroes/hero_necrolyte/hero_necrolyte", LUA_MODIFIER_MOTION_NONE)


npc_dota_hero_necrolyte_permanent_ability = class({})

function npc_dota_hero_necrolyte_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_necrolyte_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_necrolyte_permanent_ability'
end

modifier_npc_dota_hero_necrolyte_permanent_ability = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})

function modifier_npc_dota_hero_necrolyte_permanent_ability:DeclareFunctions() 
    return {
        MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT,
        MODIFIER_EVENT_ON_DEATH
    }
end

function modifier_npc_dota_hero_necrolyte_permanent_ability:GetModifierCooldownReduction_Constant(data) 
    if not IsServer() then return end
    if (not self:GetParent():PassivesDisabled()) and data.ability:GetName() == "necrolyte_reapers_scythe" then
        return self:GetAbility():GetSpecialValueFor("cd") * self:GetParent():GetKills()
    end 
end

function modifier_npc_dota_hero_necrolyte_permanent_ability:OnDeath(data)
    if data.attacker:GetName() == "npc_dota_hero_necrolyte" then
        self:SetStackCount(self:GetAbility():GetSpecialValueFor("cd") * self:GetParent():GetKills())
    end
end