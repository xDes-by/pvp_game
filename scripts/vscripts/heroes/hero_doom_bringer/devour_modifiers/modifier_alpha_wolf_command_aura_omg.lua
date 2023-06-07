modifier_alpha_wolf_command_aura_omg = modifier_alpha_wolf_command_aura_omg or class({})

--------------------------------------------------------------------------------

function modifier_alpha_wolf_command_aura_omg:IsHidden()            return true end
function modifier_alpha_wolf_command_aura_omg:IsPurgable() 		    return false end
function modifier_alpha_wolf_command_aura_omg:RemoveOnDeath()	    return false end
function modifier_alpha_wolf_command_aura_omg:IsAura()	            return not self:GetParent():PassivesDisabled() end
function modifier_alpha_wolf_command_aura_omg:GetAuraRadius()	    return self.radius end
function modifier_alpha_wolf_command_aura_omg:GetAuraSearchTeam()   return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_alpha_wolf_command_aura_omg:GetAuraSearchType()   return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_alpha_wolf_command_aura_omg:GetAuraSearchFlags()  return 0 end
function modifier_alpha_wolf_command_aura_omg:GetModifierAura()     return "modifier_alpha_wolf_command_aura_bonus_omg" end
function modifier_alpha_wolf_command_aura_omg:GetTexture()          return "alpha_wolf_command_aura" end

--------------------------------------------------------------------------------

function modifier_alpha_wolf_command_aura_omg:OnCreated(kv)
    if not IsServer() then return end
    self.radius = GetAbilitySpecial("alpha_wolf_command_aura", "radius")
end

--------------------------------------------------------------------------------

modifier_alpha_wolf_command_aura_bonus_omg = class({})

--------------------------------------------------------------------------------

function modifier_alpha_wolf_command_aura_bonus_omg:IsPurgable()       return false end
function modifier_alpha_wolf_command_aura_bonus_omg:GetTexture()       return "alpha_wolf_command_aura" end

--------------------------------------------------------------------------------

function modifier_alpha_wolf_command_aura_bonus_omg:OnCreated(kv)
    if not IsServer() then return end
    self.bonus_damage_pct = GetAbilitySpecial("alpha_wolf_command_aura", "bonus_damage_pct")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_alpha_wolf_command_aura_bonus_omg:AddCustomTransmitterData()
	return {bonus_damage_pct = self.bonus_damage_pct}
end

--------------------------------------------------------------------------------

function modifier_alpha_wolf_command_aura_bonus_omg:HandleCustomTransmitterData(data)
	self.bonus_damage_pct = data.bonus_damage_pct
end

--------------------------------------------------------------------------------

function modifier_alpha_wolf_command_aura_bonus_omg:DeclareFunctions()
    return {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE}
end

--------------------------------------------------------------------------------

function modifier_alpha_wolf_command_aura_bonus_omg:GetModifierBaseDamageOutgoing_Percentage()
    return self.bonus_damage_pct
end