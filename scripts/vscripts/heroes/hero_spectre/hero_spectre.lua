LinkLuaModifier('modifier_npc_dota_hero_spectre_permanent_ability', "heroes/hero_spectre/hero_spectre", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_spectre_permanent_ability_buff', "heroes/hero_spectre/hero_spectre", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_spectre_permanent_ability = class({})

function npc_dota_hero_spectre_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_spectre_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_spectre_permanent_ability'
end

modifier_npc_dota_hero_spectre_permanent_ability = class({
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
    OnTakeDamage = function(self,data) 
        if not self:GetParent():PassivesDisabled() and data.attacker:IsRealHero() and data.attacker:GetTeamNumber() ~= data.unit:GetTeamNumber() and data.unit == self:GetParent() then
            if not data.unit:HasModifier("modifier_npc_dota_hero_spectre_permanent_ability_buff") then
                data.unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_npc_dota_hero_spectre_permanent_ability_buff", {})
                table.insert( data.unit:FindModifierByName("modifier_npc_dota_hero_spectre_permanent_ability_buff").time , GameRules:GetDOTATime(false,false))
            else
                table.insert( data.unit:FindModifierByName("modifier_npc_dota_hero_spectre_permanent_ability_buff").time , GameRules:GetDOTATime(false,false))
                if data.unit:FindModifierByName("modifier_npc_dota_hero_spectre_permanent_ability_buff"):GetStackCount() <5 then
                    data.unit:FindModifierByName("modifier_npc_dota_hero_spectre_permanent_ability_buff"):IncrementStackCount()
                end
            end
        end
    end,
})

modifier_npc_dota_hero_spectre_permanent_ability_buff = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
            MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
        }
    end,
    GetModifierBonusStats_Strength = function(self,data) 
        return self:GetAbility():GetSpecialValueFor("str") * self:GetStackCount()
    end,
    GetModifierConstantHealthRegen = function(self,data) 
        return self:GetAbility():GetSpecialValueFor("regen") * self:GetStackCount()
    end,
})

function modifier_npc_dota_hero_spectre_permanent_ability_buff:OnCreated()
if not IsServer() then return end
    self:SetStackCount(1)
    self.time = {}
    Timers:CreateTimer(1, function()
        self:GetParent():CalculateStatBonus(true)
        if self.time[1] ~= nil then
            while GameRules:GetDOTATime(false,false) > (self.time[1] + self:GetAbility():GetSpecialValueFor("duration")) do
                self:DecrementStackCount()
                table.remove( self.time, 1 )
                if self.time[1] == nil then break end
            end
        end
        if self:GetStackCount() == 0 then self:Destroy() return end
        return 1
    end)
end