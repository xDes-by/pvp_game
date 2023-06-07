modifier_forest_troll_high_priest_heal_amp_aura_omg = modifier_forest_troll_high_priest_heal_amp_aura_omg or class({})

--------------------------------------------------------------------------------

function modifier_forest_troll_high_priest_heal_amp_aura_omg:IsHidden()             return true end
function modifier_forest_troll_high_priest_heal_amp_aura_omg:IsPurgable() 	        return false end
function modifier_forest_troll_high_priest_heal_amp_aura_omg:RemoveOnDeath()	    return false end
function modifier_forest_troll_high_priest_heal_amp_aura_omg:IsAura()	            return not self:GetParent():PassivesDisabled() end
function modifier_forest_troll_high_priest_heal_amp_aura_omg:GetAuraRadius()	    return self.radius end
function modifier_forest_troll_high_priest_heal_amp_aura_omg:GetAuraSearchTeam()    return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_forest_troll_high_priest_heal_amp_aura_omg:GetAuraSearchType()    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_forest_troll_high_priest_heal_amp_aura_omg:GetAuraSearchFlags()   return 0 end
function modifier_forest_troll_high_priest_heal_amp_aura_omg:GetModifierAura()      return "modifier_forest_troll_high_priest_heal_amp_aura_bonus_omg" end
function modifier_forest_troll_high_priest_heal_amp_aura_omg:GetTexture()           return "forest_troll_high_priest_heal_amp_aura" end

--------------------------------------------------------------------------------

function modifier_forest_troll_high_priest_heal_amp_aura_omg:OnCreated(kv)
    if not IsServer() then return end
    self.radius = GetAbilitySpecial("forest_troll_high_priest_heal_amp_aura", "radius")
end

--------------------------------------------------------------------------------

modifier_forest_troll_high_priest_heal_amp_aura_bonus_omg = class({})

--------------------------------------------------------------------------------

function modifier_forest_troll_high_priest_heal_amp_aura_bonus_omg:IsPurgable()       return false end
function modifier_forest_troll_high_priest_heal_amp_aura_bonus_omg:GetTexture()       return "forest_troll_high_priest_heal_amp_aura" end

--------------------------------------------------------------------------------

function modifier_forest_troll_high_priest_heal_amp_aura_bonus_omg:OnCreated(kv)
    if not IsServer() then return end
    self.heal_amp = GetAbilitySpecial("forest_troll_high_priest_heal_amp_aura", "heal_amp")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_forest_troll_high_priest_heal_amp_aura_bonus_omg:AddCustomTransmitterData()
	return {heal_amp = self.heal_amp}
end

--------------------------------------------------------------------------------

function modifier_forest_troll_high_priest_heal_amp_aura_bonus_omg:HandleCustomTransmitterData(data)
	self.heal_amp = data.heal_amp
end

--------------------------------------------------------------------------------

function modifier_forest_troll_high_priest_heal_amp_aura_bonus_omg:DeclareFunctions()
    return {MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_SOURCE}
end

--------------------------------------------------------------------------------

function modifier_forest_troll_high_priest_heal_amp_aura_bonus_omg:GetModifierHealAmplify_PercentageSource()
    return self.heal_amp
end