LinkLuaModifier( "modifier_npc_dota_hero_jakiro_permanent_ability", "heroes/hero_jakiro/hero_jakiro", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_jakiro_permanent_ability = class({})

function npc_dota_hero_jakiro_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_jakiro_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_jakiro_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_jakiro_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_jakiro_permanent_ability"
end

----------------------------------------------------------------------------
modifier_npc_dota_hero_jakiro_permanent_ability = class({})

function modifier_npc_dota_hero_jakiro_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_jakiro_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_jakiro_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_jakiro_permanent_ability:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_jakiro_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

function modifier_npc_dota_hero_jakiro_permanent_ability:OnDeath( params )
	if self:GetParent():PassivesDisabled() then return end
	if params.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() or params.unit:IsIllusion() or not params.unit:IsRealHero() then return end
	if params.unit:IsRealHero() and params.attacker == self:GetParent() then
	
		self:IncrementStackCount()

	end
end

function modifier_npc_dota_hero_jakiro_permanent_ability:GetModifierSpellAmplify_Percentage(params)
    return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("spell")
end