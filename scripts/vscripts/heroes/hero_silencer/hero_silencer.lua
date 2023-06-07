LinkLuaModifier( "modifier_npc_dota_hero_silencer_permanent_ability", "heroes/hero_silencer/hero_silencer", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_silencer_permanent_ability_effect", "heroes/hero_silencer/hero_silencer", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_silencer_permanent_ability = class({})

function npc_dota_hero_silencer_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_silencer_permanent_ability:IsStealable()
	return false
end

function npc_dota_hero_silencer_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_silencer_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_silencer_permanent_ability"
end
--------------------------------------------------------------------------------------------

modifier_npc_dota_hero_silencer_permanent_ability = class({})

function modifier_npc_dota_hero_silencer_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_silencer_permanent_ability:OnCreated()
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
end

function modifier_npc_dota_hero_silencer_permanent_ability:OnRefresh()
	self:OnCreated()
end

function modifier_npc_dota_hero_silencer_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_npc_dota_hero_silencer_permanent_ability:OnAttackLanded( keys )
if IsServer() then
	if self:GetParent() ~= keys.attacker then return end
	if self:GetParent():PassivesDisabled() then return end
		if self:GetParent():IsIllusion() then return end
			if RandomInt(1,100) <= self.chance then	
			keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_silence", {duration = self.duration * (1 - keys.target:GetStatusResistance())})
		end	
	end
end