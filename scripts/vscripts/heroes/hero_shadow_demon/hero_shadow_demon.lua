npc_dota_hero_shadow_demon_permanent_ability = class({})

LinkLuaModifier('modifier_npc_dota_hero_shadow_demon_permanent_ability', "heroes/hero_shadow_demon/hero_shadow_demon", LUA_MODIFIER_MOTION_NONE)

function npc_dota_hero_shadow_demon_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_shadow_demon_permanent_ability:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_shadow_demon_permanent_ability"
end

modifier_npc_dota_hero_shadow_demon_permanent_ability = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) 
        return {
            MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
        } 
    end,
    OnAbilityFullyCast = function(self,data) 
        if self:GetParent() ~= data.unit then return end 
        if data.ability == "shadow_demon_shadow_poison_release" then return end 
        if self:GetParent():GetName() ~= "npc_dota_hero_shadow_demon" then return end
        if RandomInt(1,100) <= self:GetAbility():GetSpecialValueFor("chance") then
			if RandomInt(1,2) == 1 then
				self:GetParent():Heal(self:GetAbility():GetSpecialValueFor("regen"), self:GetAbility())
			else
				self:GetParent():GiveMana(self:GetAbility():GetSpecialValueFor("regen"))
			end
		end
    end,
})


