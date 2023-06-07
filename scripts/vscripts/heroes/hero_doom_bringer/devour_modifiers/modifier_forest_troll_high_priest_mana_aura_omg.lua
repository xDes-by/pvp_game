modifier_forest_troll_high_priest_mana_aura_omg = modifier_forest_troll_high_priest_mana_aura_omg or class({})

--------------------------------------------------------------------------------

function modifier_forest_troll_high_priest_mana_aura_omg:IsHidden()             return true end
function modifier_forest_troll_high_priest_mana_aura_omg:IsPurgable() 		    return false end
function modifier_forest_troll_high_priest_mana_aura_omg:RemoveOnDeath()	    return false end
function modifier_forest_troll_high_priest_mana_aura_omg:IsAura()	            return not self:GetParent():PassivesDisabled() end
function modifier_forest_troll_high_priest_mana_aura_omg:GetAuraRadius()	    return self.radius end
function modifier_forest_troll_high_priest_mana_aura_omg:GetAuraSearchTeam()    return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_forest_troll_high_priest_mana_aura_omg:GetAuraSearchType()    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_forest_troll_high_priest_mana_aura_omg:GetAuraSearchFlags()   return 0 end
function modifier_forest_troll_high_priest_mana_aura_omg:GetModifierAura()      return "modifier_forest_troll_high_priest_mana_aura_bonus_omg" end
function modifier_forest_troll_high_priest_mana_aura_omg:GetTexture()           return "forest_troll_high_priest_mana_aura" end

--------------------------------------------------------------------------------

function modifier_forest_troll_high_priest_mana_aura_omg:OnCreated(kv)
    if not IsServer() then return end
    self.radius = GetAbilitySpecial("forest_troll_high_priest_mana_aura", "radius")
end

--------------------------------------------------------------------------------

modifier_forest_troll_high_priest_mana_aura_bonus_omg = class({})

--------------------------------------------------------------------------------

function modifier_forest_troll_high_priest_mana_aura_bonus_omg:IsPurgable()       return false end
function modifier_forest_troll_high_priest_mana_aura_bonus_omg:GetTexture()       return "forest_troll_high_priest_mana_aura" end

--------------------------------------------------------------------------------

function modifier_forest_troll_high_priest_mana_aura_bonus_omg:OnCreated(kv)
    if not IsServer() then return end
    self.mana_regen = GetAbilitySpecial("forest_troll_high_priest_mana_aura", "mana_regen")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_forest_troll_high_priest_mana_aura_bonus_omg:AddCustomTransmitterData()
	return {mana_regen = self.mana_regen}
end

--------------------------------------------------------------------------------

function modifier_forest_troll_high_priest_mana_aura_bonus_omg:HandleCustomTransmitterData(data)
	self.mana_regen = data.mana_regen
end

--------------------------------------------------------------------------------

function modifier_forest_troll_high_priest_mana_aura_bonus_omg:DeclareFunctions()
    return {MODIFIER_PROPERTY_MANA_REGEN_CONSTANT}
end

--------------------------------------------------------------------------------

function modifier_forest_troll_high_priest_mana_aura_bonus_omg:GetModifierConstantManaRegen()
    return self.mana_regen
end