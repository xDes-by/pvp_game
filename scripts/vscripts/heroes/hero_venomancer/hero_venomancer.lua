
LinkLuaModifier('modifier_npc_dota_hero_venomancer_permanent_ability', "heroes/hero_venomancer/hero_venomancer", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_venomancer_permanent_ability = class({})

function npc_dota_hero_venomancer_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_venomancer_permanent_ability'
end

function npc_dota_hero_venomancer_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

modifier_npc_dota_hero_venomancer_permanent_ability = class({
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
})

function modifier_npc_dota_hero_venomancer_permanent_ability:OnCreated()
    self.number = 1
end

function modifier_npc_dota_hero_venomancer_permanent_ability:OnAttackLanded(data)
    if (not self:GetParent():PassivesDisabled()) and data.target:GetName() == "npc_dota_hero_venomancer" and data.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not data.attacker:IsOther() and not data.attacker:IsBuilding() then
        print(self.number)
        if self.number >= self:GetAbility():GetSpecialValueFor("hits") then       
            if not self:GetParent():FindAbilityByName("special_bonus_unique_venomancer"):IsTrained() then
                local ward = CreateUnitByName("npc_dota_venomancer_plague_ward_".. self:GetParent():FindAbilityByName("venomancer_plague_ward"):GetLevel(), data.attacker:GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
                ward:SetControllableByPlayer(self:GetParent():GetPlayerID(), true)
                self.number = 1
                return
            else
                local ward = CreateUnitByName("npc_dota_venomancer_plague_ward_5", data.attacker:GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
                ward:SetControllableByPlayer(self:GetParent():GetPlayerID(), true)
                self.number = 1  
                return
            end  
        else       
            self.number = self.number + 1
        end
    end 
end
