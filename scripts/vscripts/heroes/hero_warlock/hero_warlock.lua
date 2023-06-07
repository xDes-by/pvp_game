LinkLuaModifier( "modifier_npc_dota_hero_warlock_permanent_ability", "heroes/hero_warlock/hero_warlock", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_warlock_permanent_ability_effect", "heroes/hero_warlock/hero_warlock", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_warlock_permanent_ability = class({})

function npc_dota_hero_warlock_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_warlock_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_warlock_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_warlock_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_warlock_permanent_ability"
end

----------------------------------------------------------------------------
modifier_npc_dota_hero_warlock_permanent_ability = class({})

function modifier_npc_dota_hero_warlock_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_warlock_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_warlock_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_warlock_permanent_ability:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_npc_dota_hero_warlock_permanent_ability:GetModifierAura()
	return "modifier_npc_dota_hero_warlock_permanent_ability_effect"
end

function modifier_npc_dota_hero_warlock_permanent_ability:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_npc_dota_hero_warlock_permanent_ability:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_npc_dota_hero_warlock_permanent_ability:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

-----------------------------------------------------------------------------

modifier_npc_dota_hero_warlock_permanent_ability_effect = class({})

function modifier_npc_dota_hero_warlock_permanent_ability_effect:IsHidden()
	return false
end

function modifier_npc_dota_hero_warlock_permanent_ability_effect:IsDebuff()
	return false
end

function modifier_npc_dota_hero_warlock_permanent_ability_effect:IsPurgable()
	return false
end

function modifier_npc_dota_hero_warlock_permanent_ability_effect:OnCreated( kv )
end

function modifier_npc_dota_hero_warlock_permanent_ability_effect:OnRefresh( kv )
end

function modifier_npc_dota_hero_warlock_permanent_ability_effect:OnCreated( kv )
	self:StartIntervalThink(1)
end

function modifier_npc_dota_hero_warlock_permanent_ability_effect:OnIntervalThink()
	self.gold = self:GetAbility():GetSpecialValueFor( "gold" )
	if IsServer() and self:GetParent():IsRealHero() and self:GetParent():IsAlive() and not self:GetParent():PassivesDisabled() then
		PlayerResource:ModifyGold( self:GetParent():GetPlayerOwnerID(), self.gold, false, DOTA_ModifyGold_Unspecified )	
	end
end