LinkLuaModifier( "modifier_npc_dota_hero_life_stealer_permanent_ability", "heroes/hero_life_stealer/hero_life_stealer", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_life_stealer_permanent_ability_effect", "heroes/hero_life_stealer/hero_life_stealer", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_life_stealer_permanent_ability = class({})

function npc_dota_hero_life_stealer_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_life_stealer_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_life_stealer_permanent_ability"
end

---------------------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_life_stealer_permanent_ability = class({})

function modifier_npc_dota_hero_life_stealer_permanent_ability:IsHidden()
	if self:GetStackCount() == 0 then return true end
	return false
end

function modifier_npc_dota_hero_life_stealer_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_life_stealer_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_life_stealer_permanent_ability:RemoveOnDeath()
	return false
end

function modifier_npc_dota_hero_life_stealer_permanent_ability:OnCreated( kv )
	self:SetStackCount(0)
	self.attacks = self:GetAbility():GetSpecialValueFor( "attacks" )
	self.diration = self:GetAbility():GetSpecialValueFor( "diration" )
	self.currentTarget = {}
end

function modifier_npc_dota_hero_life_stealer_permanent_ability:OnRefresh( kv )
	self.attacks = self:GetAbility():GetSpecialValueFor( "attacks" )
	self.diration = self:GetAbility():GetSpecialValueFor( "diration" )
end

function modifier_npc_dota_hero_life_stealer_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK
	}
	return funcs
end

function modifier_npc_dota_hero_life_stealer_permanent_ability:OnAttack( params )
	if IsServer() and not self:GetParent():PassivesDisabled() then
		pass = false
		if params.attacker==self:GetParent() then
			pass = true
		end

		if pass then
			if self.currentTarget==params.target then
				if self:GetStackCount() < self.attacks then
					self:IncrementStackCount()
				end
				if self:GetStackCount() == self.attacks then
					EmitSoundOn( "Hero_LifeStealer.OpenWounds.Cast", self:GetParent() )
					self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_npc_dota_hero_life_stealer_permanent_ability_effect", {duration = self.diration})
					self:SetStackCount(0)
				end
			else
				self:SetStackCount(1)
				self.currentTarget = params.target
			end
		end
	end
end

------------------------------------------------------------------------------------

modifier_npc_dota_hero_life_stealer_permanent_ability_effect = class({})

function modifier_npc_dota_hero_life_stealer_permanent_ability_effect:IsHidden( kv )
	return false
end

function modifier_npc_dota_hero_life_stealer_permanent_ability_effect:IsDebuff( kv )
	return false
end

function modifier_npc_dota_hero_life_stealer_permanent_ability_effect:IsPurgable( kv )
	return true
end

function modifier_npc_dota_hero_life_stealer_permanent_ability_effect:OnCreated( kv )
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
end

function modifier_npc_dota_hero_life_stealer_permanent_ability_effect:OnRefresh( kv )
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
end

function modifier_npc_dota_hero_life_stealer_permanent_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end

function modifier_npc_dota_hero_life_stealer_permanent_ability_effect:GetModifierPreAttack_BonusDamage( params )
	return self.damage
end

function modifier_npc_dota_hero_life_stealer_permanent_ability_effect:GetModifierAttackSpeedBonus_Constant( params )
	return self.speed
end