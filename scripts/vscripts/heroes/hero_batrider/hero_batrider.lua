LinkLuaModifier( "modifier_npc_dota_hero_batrider_permanent_ability", "heroes/hero_batrider/hero_batrider", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_batrider_permanent_ability = class({})

function npc_dota_hero_batrider_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_batrider_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_batrider_permanent_ability"
end

---------------------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_batrider_permanent_ability = class({})


function modifier_npc_dota_hero_batrider_permanent_ability:IsHidden( kv )
	if self:GetStackCount() == 0 then return true end
	return false
end

function modifier_npc_dota_hero_batrider_permanent_ability:IsDebuff( kv )
	return false
end

function modifier_npc_dota_hero_batrider_permanent_ability:IsPurgable( kv )
	return false
end

function modifier_npc_dota_hero_batrider_permanent_ability:RemoveOnDeath( kv )
	return false
end

function modifier_npc_dota_hero_batrider_permanent_ability:OnCreated( kv )
	self:SetStackCount(0)
	self.stack_multiplier = self:GetAbility():GetSpecialValueFor("as")
	self.stacks = self:GetAbility():GetSpecialValueFor("stacks")
	self.currentTarget = {}
end

function modifier_npc_dota_hero_batrider_permanent_ability:OnRefresh( kv )
	self.stack_multiplier = self:GetAbility():GetSpecialValueFor("as")
	self.stacks = self:GetAbility():GetSpecialValueFor("stacks")
end

function modifier_npc_dota_hero_batrider_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK
	}
	return funcs
end

function modifier_npc_dota_hero_batrider_permanent_ability:OnAttack( params )
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

function modifier_npc_dota_hero_batrider_permanent_ability:GetModifierAttackSpeedBonus_Constant( params )
	local passive = 1
	if self:GetParent():PassivesDisabled() then
		passive = 0
	end
	return self:GetStackCount() * self.stack_multiplier * passive
end


function modifier_npc_dota_hero_batrider_permanent_ability:AddStack()
	if not self:GetParent():PassivesDisabled() then
		if self:GetStackCount() < self.stacks then
			self:IncrementStackCount()
		end
	end
end

function modifier_npc_dota_hero_batrider_permanent_ability:ResetStack()
	if not self:GetParent():PassivesDisabled() then
		self:SetStackCount(1)
	end
end