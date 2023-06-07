LinkLuaModifier( "modifier_npc_dota_hero_phantom_assassin_permanent_ability", "heroes/hero_phantom_assassin/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_phantom_assassin_permanent_ability_effect", "heroes/hero_phantom_assassin/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_phantom_assassin_permanent_ability = class({})

function npc_dota_hero_phantom_assassin_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_phantom_assassin_permanent_ability:IsStealable()
	return false
end

function npc_dota_hero_phantom_assassin_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_phantom_assassin_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_phantom_assassin_permanent_ability"
end
--------------------------------------------------------------------------------------------

modifier_npc_dota_hero_phantom_assassin_permanent_ability = class({})

function modifier_npc_dota_hero_phantom_assassin_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_phantom_assassin_permanent_ability:OnCreated()
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

function modifier_npc_dota_hero_phantom_assassin_permanent_ability:OnRefresh()
	self:OnCreated()
end

function modifier_npc_dota_hero_phantom_assassin_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_npc_dota_hero_phantom_assassin_permanent_ability:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()

		if owner ~= keys.attacker then
			return end

		local target = keys.target
		if owner:IsIllusion() then
			return end
			if not target:HasModifier("modifier_npc_dota_hero_phantom_assassin_permanent_ability_effect") then
			target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_npc_dota_hero_phantom_assassin_permanent_ability_effect", {duration = self.duration * (1 - target:GetStatusResistance())})
		end	
	end
end

--------------------------------------------------------------------------------------

modifier_npc_dota_hero_phantom_assassin_permanent_ability_effect = class({})

function modifier_npc_dota_hero_phantom_assassin_permanent_ability_effect:IsHidden() return false end
function modifier_npc_dota_hero_phantom_assassin_permanent_ability_effect:IsDebuff() return true end
function modifier_npc_dota_hero_phantom_assassin_permanent_ability_effect:IsPurgable() return true end

function modifier_npc_dota_hero_phantom_assassin_permanent_ability_effect:OnCreated()
	self.armor_reduction = (-1) * self:GetAbility():GetSpecialValueFor("disarm")
end

function modifier_npc_dota_hero_phantom_assassin_permanent_ability_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_npc_dota_hero_phantom_assassin_permanent_ability_effect:GetModifierPhysicalArmorBonus()
	return self.armor_reduction
end