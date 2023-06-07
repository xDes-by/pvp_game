
LinkLuaModifier('modifier_npc_dota_hero_weaver_permanent_ability', "heroes/hero_weaver/hero_weaver", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_weaver_permanent_ability_debuff', "heroes/hero_weaver/hero_weaver", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_weaver_permanent_ability = class({})

function npc_dota_hero_weaver_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_weaver_permanent_ability'
end

function npc_dota_hero_weaver_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

modifier_npc_dota_hero_weaver_permanent_ability = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
	DeclareFunctions        = function(self) 
        return {
        	MODIFIER_EVENT_ON_ATTACK_LANDED,
        }
     end,
    OnAttackLanded = function(self,data) 
	    if (not self:GetParent():PassivesDisabled()) and data.attacker == self:GetParent() then
			local mod = data.target:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_npc_dota_hero_weaver_permanent_ability_debuff",{duration = self:GetAbility():GetSpecialValueFor("duration")})
        end 
     end,
})

modifier_npc_dota_hero_weaver_permanent_ability_debuff = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	} end,
})

function modifier_npc_dota_hero_weaver_permanent_ability_debuff:OnCreated()
	self:SetStackCount(1)
end

function modifier_npc_dota_hero_weaver_permanent_ability_debuff:OnRefresh()
	if self:GetStackCount() ~= 3 then
        self:IncrementStackCount()
    end
end

function modifier_npc_dota_hero_weaver_permanent_ability_debuff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armorreduce") * self:GetStackCount() * (-1)
end