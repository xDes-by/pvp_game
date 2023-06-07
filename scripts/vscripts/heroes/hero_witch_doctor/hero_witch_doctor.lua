LinkLuaModifier('modifier_npc_dota_hero_witch_doctor_permanent_ability', "heroes/hero_witch_doctor/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_witch_doctor_permanent_ability = class({})

function npc_dota_hero_witch_doctor_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_witch_doctor_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_witch_doctor_permanent_ability'
end

modifier_npc_dota_hero_witch_doctor_permanent_ability = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
            MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
            MODIFIER_PROPERTY_HEALTH_BONUS
        }
    end,
    GetModifierAttackSpeedBonus_Constant = function(self,data) 
    if self:GetParent():PassivesDisabled() then return end
        return self:GetAbility():GetSpecialValueFor("as") * -1
    end,
    GetModifierMoveSpeedBonus_Percentage = function(self,data) 
    if self:GetParent():PassivesDisabled() then return end
        return self:GetAbility():GetSpecialValueFor("move") * -1
    end,
    GetModifierPhysicalArmorBonus = function(self,data) 
    if self:GetParent():PassivesDisabled() then return end
        return self:GetAbility():GetSpecialValueFor("armor")
    end,
    GetModifierHealthBonus = function(self,data) 
    if self:GetParent():PassivesDisabled() then return end
        return self:GetAbility():GetSpecialValueFor("health")
    end,
})
