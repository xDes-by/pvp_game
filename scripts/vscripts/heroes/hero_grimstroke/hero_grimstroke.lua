npc_dota_hero_grimstroke_permanent_ability = class({})

LinkLuaModifier( "modifier_npc_dota_hero_grimstroke_permanent_ability","heroes/hero_grimstroke/hero_grimstroke" , LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_grimstroke_permanent_ability_heal","heroes/hero_grimstroke/hero_grimstroke" , LUA_MODIFIER_MOTION_NONE )

function npc_dota_hero_grimstroke_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_grimstroke_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_grimstroke_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_grimstroke_permanent_ability:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_grimstroke_permanent_ability"
end

modifier_npc_dota_hero_grimstroke_permanent_ability = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) 
        return {
            MODIFIER_EVENT_ON_TAKEDAMAGE
        } 
    end,
})

function modifier_npc_dota_hero_grimstroke_permanent_ability:OnTakeDamage(keys)
    if self:GetParent():PassivesDisabled() then return end
    if keys.inflictor and keys.inflictor:GetName() == "grimstroke_dark_artistry" and self:GetParent():GetName() == "npc_dota_hero_grimstroke" then
        if not self:GetParent():HasModifier("modifier_npc_dota_hero_grimstroke_permanent_ability_heal") then
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_npc_dota_hero_grimstroke_permanent_ability_heal", {duration = 3})
        else
            self:GetParent():FindModifierByName("modifier_npc_dota_hero_grimstroke_permanent_ability_heal"):IncrementStackCount()
        end
    end
end

modifier_npc_dota_hero_grimstroke_permanent_ability_heal = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) 
        return {
            MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
            MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
            MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
        } 
    end,
})

function modifier_npc_dota_hero_grimstroke_permanent_ability_heal:GetModifierHealthRegenPercentage()
    return self:GetAbility():GetSpecialValueFor("hp") * self:GetStackCount()
end

function modifier_npc_dota_hero_grimstroke_permanent_ability_heal:GetModifierTotalPercentageManaRegen()
    return self:GetAbility():GetSpecialValueFor("mana") * self:GetStackCount()
end

function modifier_npc_dota_hero_grimstroke_permanent_ability_heal:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("move") * self:GetStackCount()
end

function modifier_npc_dota_hero_grimstroke_permanent_ability_heal:OnCreated()
    self:SetStackCount(1)
end

