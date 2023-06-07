
-------------------------------------------------------
-- modifier_elder_titan_ancestral_spirit_lua_damage --
-------------------------------------------------------

modifier_elder_titan_ancestral_spirit_lua_damage = modifier_elder_titan_ancestral_spirit_lua_damage or class({})

-- Modifier properties
function modifier_elder_titan_ancestral_spirit_lua_damage:IsDebuff() return false end
function modifier_elder_titan_ancestral_spirit_lua_damage:IsHidden() return false end
function modifier_elder_titan_ancestral_spirit_lua_damage:IsPurgable() return false end

function modifier_elder_titan_ancestral_spirit_lua_damage:GetEffectName()
	return "particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_buff.vpcf"
end

function modifier_elder_titan_ancestral_spirit_lua_damage:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return decFuncs
end

function modifier_elder_titan_ancestral_spirit_lua_damage:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end

---------------------------------------------------
-- modifier_elder_titan_ancestral_spirit_lua_ms --
---------------------------------------------------

modifier_elder_titan_ancestral_spirit_lua_ms = modifier_elder_titan_ancestral_spirit_lua_ms or class({})

-- Modifier properties
function modifier_elder_titan_ancestral_spirit_lua_ms:IsDebuff() return false end
function modifier_elder_titan_ancestral_spirit_lua_ms:IsHidden() return false end
function modifier_elder_titan_ancestral_spirit_lua_ms:IsPurgable() return false end

function modifier_elder_titan_ancestral_spirit_lua_ms:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return decFuncs
end

function modifier_elder_titan_ancestral_spirit_lua_ms:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end

------------------------------------------------------
-- modifier_elder_titan_ancestral_spirit_lua_armor --
------------------------------------------------------

modifier_elder_titan_ancestral_spirit_lua_armor = class({})

function modifier_elder_titan_ancestral_spirit_lua_armor:IsPurgable() return false end

function modifier_elder_titan_ancestral_spirit_lua_armor:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return decFuncs
end

function modifier_elder_titan_ancestral_spirit_lua_armor:GetModifierPhysicalArmorBonus()
	return self:GetStackCount() * 0.1
end
