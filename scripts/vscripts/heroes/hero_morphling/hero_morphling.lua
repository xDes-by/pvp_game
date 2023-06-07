LinkLuaModifier( "modifier_npc_dota_hero_morphling_permanent_ability", "heroes/hero_morphling/hero_morphling", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_morphling_permanent_ability = class({})

function npc_dota_hero_morphling_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_morphling_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_morphling_permanent_ability"
end

---------------------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_morphling_permanent_ability = class({})

function modifier_npc_dota_hero_morphling_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_morphling_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_morphling_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_morphling_permanent_ability:RemoveOnDeath()
	return false
end


function modifier_npc_dota_hero_morphling_permanent_ability:OnCreated( kv )
	self.all = self:GetAbility():GetSpecialValueFor( "all" )
end

function modifier_npc_dota_hero_morphling_permanent_ability:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_npc_dota_hero_morphling_permanent_ability:OnRemoved()
end

function modifier_npc_dota_hero_morphling_permanent_ability:OnDestroy()
end

function modifier_npc_dota_hero_morphling_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
	return funcs
end

function modifier_npc_dota_hero_morphling_permanent_ability:GetModifierBonusStats_Strength()
	return self.all
end

function modifier_npc_dota_hero_morphling_permanent_ability:GetModifierBonusStats_Agility()
	return self.all
end

function modifier_npc_dota_hero_morphling_permanent_ability:GetModifierBonusStats_Intellect()
	return self.all
end