LinkLuaModifier( "modifier_npc_dota_hero_marci_permanent_ability", "heroes/hero_marci/hero_marci", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_marci_permanent_ability_effect", "heroes/hero_marci/hero_marci", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_marci_permanent_ability = class({})

function npc_dota_hero_marci_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_marci_permanent_ability:IsStealable()
	return false
end

function npc_dota_hero_marci_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_marci_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_marci_permanent_ability"
end
--------------------------------------------------------------------------------------------

modifier_npc_dota_hero_marci_permanent_ability = class({})

function modifier_npc_dota_hero_marci_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_marci_permanent_ability:OnCreated()
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	self.min = self:GetAbility():GetSpecialValueFor("min")
	self.max = self:GetAbility():GetSpecialValueFor("max")
end

function modifier_npc_dota_hero_marci_permanent_ability:OnRefresh()
	self:OnCreated()
end

function modifier_npc_dota_hero_marci_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_npc_dota_hero_marci_permanent_ability:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end
		if RandomInt(0, 100) <=  self.crit_chance then
			self.record = params.record
			local crit = RandomInt(self.min, self.max)
			return crit
		end
	end
end

function modifier_npc_dota_hero_marci_permanent_ability:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record and self.record == params.record then
			self.record = nil
			local sound_cast = "Hero_Juggernaut.BladeDance"
			EmitSoundOn( sound_cast, params.target )
		end
	end
end