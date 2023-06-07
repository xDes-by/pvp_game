LinkLuaModifier( "modifier_npc_dota_hero_ancient_apparition_permanent_ability", "heroes/hero_ancient_apparition/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_ancient_apparition_permanent_ability_effect", "heroes/hero_ancient_apparition/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_ancient_apparition_permanent_ability_no_heal", "heroes/hero_ancient_apparition/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_ancient_apparition_permanent_ability = class({})

function npc_dota_hero_ancient_apparition_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_ancient_apparition_permanent_ability:IsStealable()
	return false
end

function npc_dota_hero_ancient_apparition_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_ancient_apparition_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_ancient_apparition_permanent_ability"
end
--------------------------------------------------------------------------------------------

modifier_npc_dota_hero_ancient_apparition_permanent_ability = class({})

function modifier_npc_dota_hero_ancient_apparition_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_ancient_apparition_permanent_ability:OnCreated()
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.debuff_duration = self:GetAbility():GetSpecialValueFor("debuff_duration")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
end

function modifier_npc_dota_hero_ancient_apparition_permanent_ability:OnRefresh()
	self:OnCreated()
end

function modifier_npc_dota_hero_ancient_apparition_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_npc_dota_hero_ancient_apparition_permanent_ability:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()

		if owner ~= keys.attacker then
			return end
			
		if self:GetParent():PassivesDisabled() then return end

		local target = keys.target
		if owner:IsIllusion() then
			return end
			if RandomInt(1,100) <= self.chance then	
				if not target:HasModifier("modifier_npc_dota_hero_ancient_apparition_permanent_ability_effect") then
				target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_npc_dota_hero_ancient_apparition_permanent_ability_effect", {duration = self.duration * (1 - target:GetStatusResistance())})
				end
				if not target:HasModifier("modifier_npc_dota_hero_ancient_apparition_permanent_ability_no_heal") then
				target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_npc_dota_hero_ancient_apparition_permanent_ability_no_heal", {duration = self.debuff_duration * (1 - target:GetStatusResistance())})
			end
		end	
	end
end

--------------------------------------------------------------------------------------

modifier_npc_dota_hero_ancient_apparition_permanent_ability_effect = class({})

function modifier_npc_dota_hero_ancient_apparition_permanent_ability_effect:IsHidden() return false end
function modifier_npc_dota_hero_ancient_apparition_permanent_ability_effect:IsDebuff() return true end
function modifier_npc_dota_hero_ancient_apparition_permanent_ability_effect:IsPurgable() return true end

function modifier_npc_dota_hero_ancient_apparition_permanent_ability_effect:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_INVISIBLE] = false,
	}
	return state
end

function modifier_npc_dota_hero_ancient_apparition_permanent_ability_effect:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function modifier_npc_dota_hero_ancient_apparition_permanent_ability_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

------------------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_ancient_apparition_permanent_ability_no_heal = class({})

function modifier_npc_dota_hero_ancient_apparition_permanent_ability_no_heal:IsHidden() return false end
function modifier_npc_dota_hero_ancient_apparition_permanent_ability_no_heal:IsDebuff() return true end
function modifier_npc_dota_hero_ancient_apparition_permanent_ability_no_heal:IsPurgable() return true end

function modifier_npc_dota_hero_ancient_apparition_permanent_ability_no_heal:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DISABLE_HEALING,
	}
end

function modifier_npc_dota_hero_ancient_apparition_permanent_ability_no_heal:GetDisableHealing()
	return 1
end