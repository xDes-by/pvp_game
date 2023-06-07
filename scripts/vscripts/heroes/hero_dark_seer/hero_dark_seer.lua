npc_dota_hero_dark_seer_permanent_ability = class({})

LinkLuaModifier( "modifier_npc_dota_hero_dark_seer_permanent_ability","heroes/hero_dark_seer/hero_dark_seer" , LUA_MODIFIER_MOTION_NONE )

function npc_dota_hero_dark_seer_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_dark_seer_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_dark_seer_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_dark_seer_permanent_ability:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_dark_seer_permanent_ability"
end

modifier_npc_dota_hero_dark_seer_permanent_ability = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) 
        return {
            MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
        } 
    end,
})

function modifier_npc_dota_hero_dark_seer_permanent_ability:GetModifierIncomingDamage_Percentage(keys)
    if self:GetParent():PassivesDisabled() then return end
    return self:GetAbility():GetSpecialValueFor("damage")* math.ceil(10-self:GetParent():GetHealthPercent()/10)
end