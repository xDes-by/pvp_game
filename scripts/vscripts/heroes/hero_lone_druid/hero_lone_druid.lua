npc_dota_hero_lone_druid_permanent_ability = class({})

LinkLuaModifier('modifier_npc_dota_hero_lone_druid_permanent_ability', "heroes/hero_lone_druid/hero_lone_druid", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_lone_druid_permanent_ability_bear', "heroes/hero_lone_druid/hero_lone_druid", LUA_MODIFIER_MOTION_NONE)

function npc_dota_hero_lone_druid_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_lone_druid_permanent_ability:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_lone_druid_permanent_ability"
end

modifier_npc_dota_hero_lone_druid_permanent_ability = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) 
        return {
            MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
        } 
    end,
    GetModifierMagicalResistanceBonus = function(self) return self:GetAbility():GetSpecialValueFor("rezist") end,
})

function modifier_npc_dota_hero_lone_druid_permanent_ability:OnCreated()
    ListenToGameEvent('npc_spawned', Dynamic_Wrap(modifier_npc_dota_hero_lone_druid_permanent_ability, 'OnNPCSpawned'), self)
end	

function modifier_npc_dota_hero_lone_druid_permanent_ability:OnNPCSpawned(data)
    npc = EntIndexToHScript(data.entindex)	
    if not IsServer() then return end
    if npc:GetName() == "npc_dota_lone_druid_bear" then 
        npc:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_npc_dota_hero_lone_druid_permanent_ability_bear",{})
    end
end

modifier_npc_dota_hero_lone_druid_permanent_ability_bear = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) 
        return {
            MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
        } 
    end,
    GetModifierMagicalResistanceBonus = function(self) return self:GetAbility():GetSpecialValueFor("rezist") end,
})