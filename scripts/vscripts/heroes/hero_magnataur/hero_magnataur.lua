LinkLuaModifier( "modifier_npc_dota_hero_magnataur_permanent_ability", "heroes/hero_magnataur/hero_magnataur", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_magnataur_permanent_ability_sabre", "heroes/hero_magnataur/hero_magnataur", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_magnataur_permanent_ability_haste", "heroes/hero_magnataur/hero_magnataur", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_magnataur_permanent_ability = class({})

function npc_dota_hero_magnataur_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_magnataur_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_magnataur_permanent_ability_sabre"
end

function npc_dota_hero_magnataur_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_magnataur_permanent_ability:IsRefreshable()
	return false 
end
----------------------------------------------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_magnataur_permanent_ability_sabre = modifier_npc_dota_hero_magnataur_permanent_ability_sabre or class({})

function modifier_npc_dota_hero_magnataur_permanent_ability_sabre:IsPurgable()		return false end
function modifier_npc_dota_hero_magnataur_permanent_ability_sabre:RemoveOnDeath()	return false end
function modifier_npc_dota_hero_magnataur_permanent_ability_sabre:IsHidden() return false end

function modifier_npc_dota_hero_magnataur_permanent_ability_sabre:OnCreated()
end

function modifier_npc_dota_hero_magnataur_permanent_ability_sabre:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK
	}
end

function modifier_npc_dota_hero_magnataur_permanent_ability_sabre:OnAttack(keys)
	if keys.attacker == self:GetParent() and self:GetAbility() and not self:GetParent():IsIllusion() and not self:GetParent():PassivesDisabled() then
		if not self:GetParent():IsRangedAttacker() then 
			if self:GetAbility():IsCooldownReady() and not keys.no_attack_cooldown then
				self:GetAbility():UseResources(false,false,true)				
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_npc_dota_hero_magnataur_permanent_ability_haste", {})
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_magnataur_permanent_ability_haste = modifier_npc_dota_hero_magnataur_permanent_ability_haste or class({})
function modifier_npc_dota_hero_magnataur_permanent_ability_haste:IsDebuff() return false end
function modifier_npc_dota_hero_magnataur_permanent_ability_haste:IsHidden() return false end
function modifier_npc_dota_hero_magnataur_permanent_ability_haste:IsPurgable() return false end
function modifier_npc_dota_hero_magnataur_permanent_ability_haste:IsPurgeException() return false end
function modifier_npc_dota_hero_magnataur_permanent_ability_haste:IsStunDebuff() return false end
function modifier_npc_dota_hero_magnataur_permanent_ability_haste:RemoveOnDeath() return true end

function modifier_npc_dota_hero_magnataur_permanent_ability_haste:OnCreated()
	local current_speed = self:GetParent():GetIncreasedAttackSpeed()
	current_speed = current_speed * 2

	local max_hits = 2
	self:SetStackCount(max_hits)
	self.attack_speed_buff = math.max(500, current_speed)
end

function modifier_npc_dota_hero_magnataur_permanent_ability_haste:OnRefresh()
	self:OnCreated()
end

function modifier_npc_dota_hero_magnataur_permanent_ability_haste:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK
	}
end

function modifier_npc_dota_hero_magnataur_permanent_ability_haste:OnAttack(keys)
	if self:GetParent() == keys.attacker then
		self:SetStackCount(self:GetStackCount() - 1)
		if self:GetStackCount() == 1 then
			self:Destroy()
		end
	end
end

function modifier_npc_dota_hero_magnataur_permanent_ability_haste:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_buff
end