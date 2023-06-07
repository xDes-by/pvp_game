LinkLuaModifier( "modifier_npc_dota_hero_void_spirit_permanent_ability", "heroes/hero_void_spirit/hero_void_spirit", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_void_spirit_permanent_ability_debuff", "heroes/hero_void_spirit/hero_void_spirit", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_void_spirit_permanent_ability = class({})

function npc_dota_hero_void_spirit_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_void_spirit_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_void_spirit_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_void_spirit_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_void_spirit_permanent_ability"
end

----------------------------------------------------------------------------
modifier_npc_dota_hero_void_spirit_permanent_ability = class({})

function modifier_npc_dota_hero_void_spirit_permanent_ability:IsHidden()
	if self:GetStackCount()< 1 then
		return true
	end
	return false
end

function modifier_npc_dota_hero_void_spirit_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_void_spirit_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_void_spirit_permanent_ability:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_void_spirit_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

function modifier_npc_dota_hero_void_spirit_permanent_ability:OnDeath( params )
	if self:GetParent():PassivesDisabled() then return end
	if params.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() or params.unit:IsIllusion() or not params.unit:IsRealHero() then return end
	if not params.unit:FindModifierByNameAndCaster( "modifier_npc_dota_hero_void_spirit_permanent_ability_debuff", self:GetParent() ) then return end
	
	self:IncrementStackCount()
	self:GetParent():CalculateStatBonus(true)
end

function modifier_npc_dota_hero_void_spirit_permanent_ability:GetModifierBonusStats_Intellect(params)
    return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("int")
end

function modifier_npc_dota_hero_void_spirit_permanent_ability:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_npc_dota_hero_void_spirit_permanent_ability:GetModifierAura()
	return "modifier_npc_dota_hero_void_spirit_permanent_ability_debuff"
end

function modifier_npc_dota_hero_void_spirit_permanent_ability:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_npc_dota_hero_void_spirit_permanent_ability:GetAuraDuration()
	return 0.2
end

function modifier_npc_dota_hero_void_spirit_permanent_ability:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_npc_dota_hero_void_spirit_permanent_ability:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_npc_dota_hero_void_spirit_permanent_ability:IsAuraActiveOnDeath()
	return false
end

function modifier_npc_dota_hero_void_spirit_permanent_ability:GetAuraEntityReject( hEntity )
	if IsServer() then
		if hEntity==self:GetCaster() then return true end
	end

	return false
end

-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------

modifier_npc_dota_hero_void_spirit_permanent_ability_debuff = class({})

function modifier_npc_dota_hero_void_spirit_permanent_ability_debuff:IsHidden()
	return true
end

function modifier_npc_dota_hero_void_spirit_permanent_ability_debuff:IsPurgable()
	return false
end