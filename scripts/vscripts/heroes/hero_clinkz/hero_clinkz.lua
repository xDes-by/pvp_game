LinkLuaModifier('modifier_npc_dota_hero_clinkz_permanent_ability', "heroes/hero_clinkz/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_clinkz_permanent_ability_effect', "heroes/hero_clinkz/hero_clinkz", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_clinkz_permanent_ability = class({})

function npc_dota_hero_clinkz_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_clinkz_permanent_ability'
end

function npc_dota_hero_clinkz_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end


modifier_npc_dota_hero_clinkz_permanent_ability = class({})

function modifier_npc_dota_hero_clinkz_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_clinkz_permanent_ability:OnCreated()
	self:SetStackCount(1)
	self.count = self:GetAbility():GetSpecialValueFor("count")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.currentTarget = {}
end

function modifier_npc_dota_hero_clinkz_permanent_ability:OnRefresh()
	self:OnCreated()
end

function modifier_npc_dota_hero_clinkz_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_npc_dota_hero_clinkz_permanent_ability:OnAttackLanded( params )
	if IsServer() then
		pass = false
		if params.attacker==self:GetParent() then
			pass = true
		end

		if pass then
			if self.currentTarget==params.target then
				self:AddStack()
			else
				self:ResetStack()
				self.currentTarget = params.target
			end
		end
	end
end

function modifier_npc_dota_hero_clinkz_permanent_ability:AddStack()
	if not self:GetParent():PassivesDisabled() then
		if self:GetStackCount() < self.count then
			self:SetStackCount(self:GetStackCount() + 1)
		end
		if self:GetStackCount() == self.count then
			local pos = self:GetCaster():GetAbsOrigin() + RandomVector(250)
			local archer = CreateUnitByName("npc_dota_clinkz_skeleton_archer", pos, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
			archer:AddNewModifier(self:GetCaster(), nil, "modifier_npc_dota_hero_clinkz_permanent_ability_effect", {})
			archer:AddNewModifier(self:GetCaster(), nil, "modifier_kill", {duration = self.duration})
			archer:SetForwardVector(self:GetCaster():GetForwardVector())
			self:ResetStack()
		end
	end
end

function modifier_npc_dota_hero_clinkz_permanent_ability:ResetStack()
	if not self:GetParent():PassivesDisabled() then
		self:SetStackCount(1)
	end
end

-------------------------------------------------------------

modifier_npc_dota_hero_clinkz_permanent_ability_effect	= modifier_npc_dota_hero_clinkz_permanent_ability_effect or class({})

function modifier_npc_dota_hero_clinkz_permanent_ability_effect:IsHidden()	return true end
function modifier_npc_dota_hero_clinkz_permanent_ability_effect:IsPurgable()	return true end

function modifier_npc_dota_hero_clinkz_permanent_ability_effect:OnCreated()
	if not IsServer() then return end
	local abil = self:GetParent():FindAbilityByName("clinkz_searing_arrows")
	abil:ToggleAutoCast()
	self:SetStackCount(self:GetCaster():GetBaseDamageMin())
end

function modifier_npc_dota_hero_clinkz_permanent_ability_effect:DeclareFunctions()
	return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}
end

function modifier_npc_dota_hero_clinkz_permanent_ability_effect:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end