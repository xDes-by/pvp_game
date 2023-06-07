LinkLuaModifier( "modifier_npc_dota_hero_treant_permanent_ability", "heroes/hero_treant/hero_treant", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_treant_permanent_ability_effect", "heroes/hero_treant/hero_treant", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_treant_permanent_ability = class({})

function npc_dota_hero_treant_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_treant_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_treant_permanent_ability"
end

function npc_dota_hero_treant_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_treant_permanent_ability:IsRefreshable()
	return false 
end

---------------------------------------------------------------------------------------

modifier_npc_dota_hero_treant_permanent_ability = class({})

function modifier_npc_dota_hero_treant_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_treant_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_treant_permanent_ability:OnCreated( kv )
	self:StartIntervalThink(0.2)
end

function modifier_npc_dota_hero_treant_permanent_ability:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_npc_dota_hero_treant_permanent_ability:OnAttackLanded(data)
    if (not self:GetParent():PassivesDisabled()) and data.target == self:GetParent() and data.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not data.attacker:IsOther() and not data.attacker:IsBuilding() then
		if RandomInt(1,100) <= self:GetAbility():GetSpecialValueFor("chance") then
			if self:GetAbility():IsCooldownReady() then
				local line_pos = data.attacker:GetAbsOrigin() + data.attacker:GetForwardVector() * 150
				CreateTempTree(line_pos, 3 )
				self:GetAbility():UseResources(false, false, true)
			end
        end
    end 
end


function modifier_npc_dota_hero_treant_permanent_ability:OnIntervalThink()
if self:GetParent():PassivesDisabled() then return end
	if IsServer() then
		self.radius	= self:GetAbility():GetSpecialValueFor("radius")
		if GridNav:IsNearbyTree(self:GetParent():GetAbsOrigin(), self.radius, false) then	
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_npc_dota_hero_treant_permanent_ability_effect", {})
		else
			if self:GetParent():HasModifier("modifier_npc_dota_hero_treant_permanent_ability_effect") then
				self:GetParent():RemoveModifierByName("modifier_npc_dota_hero_treant_permanent_ability_effect")
			end
		end
	end
end

-------------------------------------------------------------------------------------

modifier_npc_dota_hero_treant_permanent_ability_effect = class({})

function modifier_npc_dota_hero_treant_permanent_ability_effect:IsHidden()
	return false
end

function modifier_npc_dota_hero_treant_permanent_ability_effect:IsPurgable()
	return false
end

function modifier_npc_dota_hero_treant_permanent_ability_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
end

function modifier_npc_dota_hero_treant_permanent_ability_effect:GetModifierHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("hp")
end