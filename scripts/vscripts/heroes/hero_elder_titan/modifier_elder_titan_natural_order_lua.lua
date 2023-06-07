modifier_elder_titan_natural_order_lua = modifier_elder_titan_natural_order_lua or class({})

-- Modifier properties
function modifier_elder_titan_natural_order_lua:IsDebuff() return true end
function modifier_elder_titan_natural_order_lua:IsHidden() return false end
function modifier_elder_titan_natural_order_lua:IsPurgable() return false end

function modifier_elder_titan_natural_order_lua:GetEffectName()
	return "particles/units/heroes/hero_elder_titan/elder_titan_natural_order_physical.vpcf"
end

function modifier_elder_titan_natural_order_lua:OnCreated()
	if not self:GetAbility() or self:GetAbility():IsNull() then self:Destroy() return end

	self.base_armor_reduction = -self:GetAbility():GetSpecialValueFor("armor_reduction_pct")
end

function modifier_elder_titan_natural_order_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_elder_titan_natural_order_lua:GetModifierPhysicalArmorBonus()
	return self.base_armor_reduction * 0.01 * self:GetParent():GetPhysicalArmorBaseValue()
end

