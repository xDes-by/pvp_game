npc_dota_hero_troll_warlord_permanent_ability = class({})

LinkLuaModifier('modifier_npc_dota_hero_troll_warlord_permanent_ability', "heroes/hero_troll_warlord/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function npc_dota_hero_troll_warlord_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_troll_warlord_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_troll_warlord_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_troll_warlord_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_troll_warlord_permanent_ability"
end

--------------------------------------------------------------------------------
modifier_npc_dota_hero_troll_warlord_permanent_ability = class({})

function modifier_npc_dota_hero_troll_warlord_permanent_ability:IsHidden()
	if self:GetStackCount() >= 1 then 
		return false
	else
		return true
	end
end

function modifier_npc_dota_hero_troll_warlord_permanent_ability:IsDebuff( kv )
	return false
end

function modifier_npc_dota_hero_troll_warlord_permanent_ability:IsPurgable( kv )
	return false
end

--------------------------------------------------------------------------------
-- Life cycle

function modifier_npc_dota_hero_troll_warlord_permanent_ability:OnCreated( kv )
	self:SetStackCount(0)
	self.currentTarget = {}
	self.stack_multiplier = self:GetAbility():GetSpecialValueFor("agi")
	self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
end

function modifier_npc_dota_hero_troll_warlord_permanent_ability:OnRefresh( kv )
	self.stack_multiplier = self:GetAbility():GetSpecialValueFor("agi")
	self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
end

--------------------------------------------------------------------------------
-- Declare functions

function modifier_npc_dota_hero_troll_warlord_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_ATTACK
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_npc_dota_hero_troll_warlord_permanent_ability:OnAttack( params )
    if self:GetParent():PassivesDisabled() then self:ResetStack() return end
	if IsServer() then
		-- filter
		pass = false
		if params.attacker==self:GetParent() and RandomInt(1,100) <= self:GetAbility():GetSpecialValueFor("chance") then
			pass = true
		end

		-- logic
		if pass then
			-- check if it is the same target
			if self.currentTarget==params.target then
				self:AddStack()
			else
				self:ResetStack()
				self.currentTarget = params.target
			end
		end
	end
end

function modifier_npc_dota_hero_troll_warlord_permanent_ability:GetModifierBonusStats_Strength( params )
	local passive = 1
	if self:GetParent():PassivesDisabled() then
		passive = 0
	end
	return self:GetStackCount() * self.stack_multiplier * passive
end
function modifier_npc_dota_hero_troll_warlord_permanent_ability:GetModifierBonusStats_Agility( params )
	local passive = 1
	if self:GetParent():PassivesDisabled() then
		passive = 0
	end
	return self:GetStackCount() * self.stack_multiplier * passive
end
function modifier_npc_dota_hero_troll_warlord_permanent_ability:GetModifierBonusStats_Intellect( params )
	local passive = 1
	if self:GetParent():PassivesDisabled() then
		passive = 0
	end
	return self:GetStackCount() * self.stack_multiplier * passive
end
--------------------------------------------------------------------------------
-- Helper functions

function modifier_npc_dota_hero_troll_warlord_permanent_ability:AddStack()
	if not self:GetParent():PassivesDisabled() then
		if self:GetStackCount() < self.max_stacks then
			self:IncrementStackCount()
		end
	end
end

function modifier_npc_dota_hero_troll_warlord_permanent_ability:ResetStack()
	if not self:GetParent():PassivesDisabled() then
		self:SetStackCount(0)
	end
end
