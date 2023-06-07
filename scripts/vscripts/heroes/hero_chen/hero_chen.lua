LinkLuaModifier( "modifier_npc_dota_hero_chen_permanent_ability", "heroes/hero_chen/hero_chen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_chen_permanent_ability_effect", "heroes/hero_chen/hero_chen", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_chen_permanent_ability = class({})

function npc_dota_hero_chen_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_chen_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_chen_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_chen_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_chen_permanent_ability"
end

----------------------------------------------------------------------------
modifier_npc_dota_hero_chen_permanent_ability = class({})

function modifier_npc_dota_hero_chen_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_chen_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_chen_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_chen_permanent_ability:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_npc_dota_hero_chen_permanent_ability:GetModifierAura()
	return "modifier_npc_dota_hero_chen_permanent_ability_effect"
end

function modifier_npc_dota_hero_chen_permanent_ability:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_npc_dota_hero_chen_permanent_ability:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_npc_dota_hero_chen_permanent_ability:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

-----------------------------------------------------------------------------

modifier_npc_dota_hero_chen_permanent_ability_effect = class({})

function modifier_npc_dota_hero_chen_permanent_ability_effect:IsHidden()
	return false
end

function modifier_npc_dota_hero_chen_permanent_ability_effect:IsDebuff()
	return false
end

function modifier_npc_dota_hero_chen_permanent_ability_effect:IsPurgable()
	return false
end

function modifier_npc_dota_hero_chen_permanent_ability_effect:OnCreated( kv )
	self.resist = self:GetAbility():GetSpecialValueFor( "resist" )
end

function modifier_npc_dota_hero_chen_permanent_ability_effect:OnRefresh( kv )
	self.resist = self:GetAbility():GetSpecialValueFor( "resist" )
end

function modifier_npc_dota_hero_chen_permanent_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE 
	}
	return funcs
end

function modifier_npc_dota_hero_chen_permanent_ability_effect:GetModifierMagicalResistanceBonus()
	return self.resist
end

function modifier_npc_dota_hero_chen_permanent_ability_effect:GetModifierStatusResistance()
	return self.resist
end