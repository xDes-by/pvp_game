modifier_elder_titan_natural_order_spirit_lua = modifier_elder_titan_natural_order_spirit_lua or class({})

-- Modifier properties
function modifier_elder_titan_natural_order_spirit_lua:IsDebuff() return true end
function modifier_elder_titan_natural_order_spirit_lua:IsHidden() return false end
function modifier_elder_titan_natural_order_spirit_lua:IsPurgable() return false end

function modifier_elder_titan_natural_order_spirit_lua:GetTexture() return "elder_titan_natural_order_spirit" end

function modifier_elder_titan_natural_order_spirit_lua:GetEffectName()
	return "particles/units/heroes/hero_elder_titan/elder_titan_natural_order_magical.vpcf"
end

function modifier_elder_titan_natural_order_spirit_lua:OnCreated()
	if not self:GetAbility() or self:GetAbility():IsNull() then self:Destroy() return end

	self.magic_resist_reduction = -self:GetAbility():GetSpecialValueFor("magic_resistance_pct")
end

function modifier_elder_titan_natural_order_spirit_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION,
	}
end

function modifier_elder_titan_natural_order_spirit_lua:GetModifierMagicalResistanceDirectModification()
	return self.magic_resist_reduction * 0.01 * self:GetParent():GetBaseMagicalResistanceValue()
end

