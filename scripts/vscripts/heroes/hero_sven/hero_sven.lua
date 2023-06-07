LinkLuaModifier('modifier_npc_dota_hero_sven_permanent_ability', "heroes/hero_sven/hero_sven", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_sven_permanent_ability_debuff', "heroes/hero_sven/hero_sven", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_sven_permanent_ability = class({})

function npc_dota_hero_sven_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_sven_permanent_ability'
end

function npc_dota_hero_sven_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

modifier_npc_dota_hero_sven_permanent_ability = class({})

function modifier_npc_dota_hero_sven_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_sven_permanent_ability:OnCreated()
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
end

function modifier_npc_dota_hero_sven_permanent_ability:OnRefresh()
	self:OnCreated()
end

function modifier_npc_dota_hero_sven_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_npc_dota_hero_sven_permanent_ability:OnAttackLanded( keys )
	if IsServer() then
		if self:GetParent():PassivesDisabled() then return end
		if self:GetParent() ~= keys.attacker then return end
		if self:GetParent():IsIllusion() then return end
			if RandomInt(1,100) <= self.chance then	
				if not keys.target:HasModifier("modifier_npc_dota_hero_sven_permanent_ability_debuff") and not keys.target:IsMagicImmune() then
				keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_npc_dota_hero_sven_permanent_ability_debuff", {duration = self.duration * (1 - keys.target:GetStatusResistance())})
			end
		end	
	end
end

------------------------------------------------------------------------------

modifier_npc_dota_hero_sven_permanent_ability_debuff = class({})

function modifier_npc_dota_hero_sven_permanent_ability_debuff:IsHidden() return false end
function modifier_npc_dota_hero_sven_permanent_ability_debuff:IsDebuff() return true end
function modifier_npc_dota_hero_sven_permanent_ability_debuff:IsPurgable() return true end

function modifier_npc_dota_hero_sven_permanent_ability_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_npc_dota_hero_sven_permanent_ability_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slowms") * (-1)
end

function modifier_npc_dota_hero_sven_permanent_ability_debuff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("slowas") * (-1)
end