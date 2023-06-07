npc_dota_hero_visage_permanent_ability = class({})

LinkLuaModifier('modifier_npc_dota_hero_visage_permanent_ability', "heroes/hero_visage/hero_visage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_visage_permanent_ability_bird', "heroes/hero_visage/hero_visage", LUA_MODIFIER_MOTION_NONE)

function npc_dota_hero_visage_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_visage_permanent_ability:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_visage_permanent_ability"
end

modifier_npc_dota_hero_visage_permanent_ability = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) 
        return {
            MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
        } 
    end,
    GetModifierPreAttack_BonusDamage = function(self) return self:GetAbility():GetSpecialValueFor("damage") end,
})

function modifier_npc_dota_hero_visage_permanent_ability:OnCreated()
    ListenToGameEvent('npc_spawned', Dynamic_Wrap(modifier_npc_dota_hero_visage_permanent_ability, 'OnNPCSpawned'), self)
end	

function modifier_npc_dota_hero_visage_permanent_ability:OnNPCSpawned(data)
    npc = EntIndexToHScript(data.entindex)	
    if not IsServer() then return end
    if npc:GetName() == "npc_dota_visage_familiar" then 
        npc:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_npc_dota_hero_visage_permanent_ability_bird",{})
    end
end

modifier_npc_dota_hero_visage_permanent_ability_bird = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) 
        return {
            MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
        } 
    end,
    GetModifierPreAttack_BonusDamage = function(self) return self:GetAbility():GetSpecialValueFor("damage") end,
})