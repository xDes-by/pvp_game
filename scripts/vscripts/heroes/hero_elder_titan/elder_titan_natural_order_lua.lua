elder_titan_natural_order_lua = elder_titan_natural_order_lua or class({})
LinkLuaModifier("modifier_elder_titan_natural_order_lua_aura", "heroes/hero_elder_titan/elder_titan_natural_order_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elder_titan_natural_order_lua_spirit_aura", "heroes/hero_elder_titan/elder_titan_natural_order_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elder_titan_natural_order_lua", "heroes/hero_elder_titan/modifier_elder_titan_natural_order_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elder_titan_natural_order_spirit_lua", "heroes/hero_elder_titan/modifier_elder_titan_natural_order_spirit_lua", LUA_MODIFIER_MOTION_NONE)

function elder_titan_natural_order_lua:GetAbilityTextureName()
	return "elder_titan_natural_order"
end

function elder_titan_natural_order_lua:GetCastRange()
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end

function elder_titan_natural_order_lua:GetIntrinsicModifierName()
	return "modifier_elder_titan_natural_order_lua_aura"
end

-- Physical Armor component

modifier_elder_titan_natural_order_lua_aura = modifier_elder_titan_natural_order_lua_aura or class({})

-- Modifier properties
function modifier_elder_titan_natural_order_lua_aura:IsAura()
	if not self:GetCaster() or self:GetCaster():IsNull() or not self:GetAbility() or self:GetAbility():IsNull() then return false end

	if self:GetCaster():PassivesDisabled() or self:GetAbility():GetLevel() < 1 then return false end

	return true
end
function modifier_elder_titan_natural_order_lua_aura:IsAuraActiveOnDeath() return false end
function modifier_elder_titan_natural_order_lua_aura:IsDebuff() return false end
function modifier_elder_titan_natural_order_lua_aura:IsHidden() return true end
function modifier_elder_titan_natural_order_lua_aura:RemoveOnDeath() return false end
function modifier_elder_titan_natural_order_lua_aura:IsPurgable() return false end

function modifier_elder_titan_natural_order_lua_aura:OnCreated()
	if not self:GetAbility() or self:GetAbility():IsNull() then return end
	local ability = self:GetAbility()

	self.natural_order_radius = self:GetAbility():GetSpecialValueFor("radius")

	if IsServer() then
		CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_elder_titan_natural_order_lua_spirit_aura", {}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
	end
end

-- Aura properties
function modifier_elder_titan_natural_order_lua_aura:GetAuraRadius()
	return self.natural_order_radius
end

function modifier_elder_titan_natural_order_lua_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_elder_titan_natural_order_lua_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_elder_titan_natural_order_lua_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_elder_titan_natural_order_lua_aura:GetModifierAura()
	return "modifier_elder_titan_natural_order_lua"
end

function modifier_elder_titan_natural_order_lua_aura:GetAuraDuration()
	return 1
end

-- Magical Resistance component

modifier_elder_titan_natural_order_lua_spirit_aura = class(modifier_elder_titan_natural_order_lua_aura)
function modifier_elder_titan_natural_order_lua_spirit_aura:IsAuraActiveOnDeath() return false end
function modifier_elder_titan_natural_order_lua_spirit_aura:IsAura()
	if not self:GetAbility() or self:GetAbility():IsNull() or not self:GetCaster() or self:GetCaster():IsNull() then return false end
	-- Break only disables the physical component of Natural Order because the Astral Spirit carries the magical component, very interesting
	if self:GetAbility():GetLevel() < 1 then return false end

	return true
end
function modifier_elder_titan_natural_order_lua_spirit_aura:OnCreated()
	if not self:GetAbility() or self:GetAbility():IsNull() then return end
	local ability = self:GetAbility()

	self.natural_order_radius = self:GetAbility():GetSpecialValueFor("radius")

	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_elder_titan_natural_order_lua_spirit_aura:OnIntervalThink()
	if not self:GetCaster() or self:GetCaster():IsNull() then
		self:Destroy()
		return
	end

	-- The astral spirit "carries" the magical reduction part of Natural Order
	local astral_spirit = self:GetCaster().astral_spirit
	if not astral_spirit or astral_spirit:IsNull() then
		self:GetParent():SetAbsOrigin(self:GetCaster():GetAbsOrigin())
	else
		self:GetParent():SetAbsOrigin(astral_spirit:GetAbsOrigin())
	end
end

function modifier_elder_titan_natural_order_lua_spirit_aura:GetModifierAura()
	return "modifier_elder_titan_natural_order_spirit_lua"
end
