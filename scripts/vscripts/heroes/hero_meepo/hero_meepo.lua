LinkLuaModifier( "modifier_npc_dota_hero_meepo_permanent_ability", "heroes/hero_meepo/hero_meepo", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_meepo_permanent_ability = class({})

function npc_dota_hero_meepo_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_meepo_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_meepo_permanent_ability"
end

---------------------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_meepo_permanent_ability = class({})

function modifier_npc_dota_hero_meepo_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_meepo_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_meepo_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_meepo_permanent_ability:RemoveOnDeath()
	return false
end


function modifier_npc_dota_hero_meepo_permanent_ability:OnCreated( kv )
	self.exp = self:GetAbility():GetSpecialValueFor( "exp" )
end

function modifier_npc_dota_hero_meepo_permanent_ability:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_npc_dota_hero_meepo_permanent_ability:OnRemoved()
end

function modifier_npc_dota_hero_meepo_permanent_ability:OnDestroy()
end

function modifier_npc_dota_hero_meepo_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXP_RATE_BOOST,
	}
	return funcs
end

function modifier_npc_dota_hero_meepo_permanent_ability:GetModifierPercentageExpRateBoost()
	return self.exp
end