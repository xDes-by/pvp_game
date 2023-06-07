LinkLuaModifier('modifier_npc_dota_hero_lich_permanent_ability', "heroes/hero_lich/hero_lich", LUA_MODIFIER_MOTION_NONE)


npc_dota_hero_lich_permanent_ability = class({})

function npc_dota_hero_lich_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_lich_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_lich_permanent_ability'
end

modifier_npc_dota_hero_lich_permanent_ability = class({
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
    GetModifierPercentageCooldown = function(self,data) 
	    if (not self:GetParent():PassivesDisabled()) then
            return self:GetAbility():GetSpecialValueFor("cd")
        end 
     end,
})
