npc_dota_hero_pugna_permanent_ability = class({})

LinkLuaModifier("modifier_npc_dota_hero_pugna_permanent_ability_aura", "heroes/hero_pugna/hero_pugna", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_npc_dota_hero_pugna_permanent_ability_debuff", "heroes/hero_pugna/hero_pugna", LUA_MODIFIER_MOTION_NONE)

function npc_dota_hero_pugna_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_pugna_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_pugna_permanent_ability_aura"
end

-----------------------------------------------------------------------------
modifier_npc_dota_hero_pugna_permanent_ability_aura = class({})

function modifier_npc_dota_hero_pugna_permanent_ability_aura:IsHidden()
	return true
end

function modifier_npc_dota_hero_pugna_permanent_ability_aura:IsPurgable()
	return false
end

function modifier_npc_dota_hero_pugna_permanent_ability_aura:IsAura()
	return (not self:GetParent():PassivesDisabled())
end

function modifier_npc_dota_hero_pugna_permanent_ability_aura:GetModifierAura()
	return "modifier_npc_dota_hero_pugna_permanent_ability_debuff"
end

function modifier_npc_dota_hero_pugna_permanent_ability_aura:GetAuraRadius()
	return 600
end

function modifier_npc_dota_hero_pugna_permanent_ability_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_npc_dota_hero_pugna_permanent_ability_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

---------------------------------------------------------------------------------------

modifier_npc_dota_hero_pugna_permanent_ability_debuff = class({})

function modifier_npc_dota_hero_pugna_permanent_ability_debuff:IsHidden()
	return false
end

function modifier_npc_dota_hero_pugna_permanent_ability_debuff:IsDebuff()
	return true
end

function modifier_npc_dota_hero_pugna_permanent_ability_debuff:IsPurgable()
	return true
end

function modifier_npc_dota_hero_pugna_permanent_ability_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_npc_dota_hero_pugna_permanent_ability_debuff:OnCreated( kv )
	self:SetStackCount(0)
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("delay"))
end

function modifier_npc_dota_hero_pugna_permanent_ability_debuff:OnIntervalThink()
	if self:GetStackCount() < self:GetAbility():GetSpecialValueFor("count") then
		self:SetStackCount(self:GetStackCount()+1)	
	end
end

function modifier_npc_dota_hero_pugna_permanent_ability_debuff:GetModifierTotalDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("debuff") * self:GetStackCount() * (-1)
end