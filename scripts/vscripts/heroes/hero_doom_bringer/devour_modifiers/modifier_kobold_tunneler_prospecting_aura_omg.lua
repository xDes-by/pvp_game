modifier_kobold_tunneler_prospecting_aura_omg = modifier_kobold_tunneler_prospecting_aura_omg or class({})

--------------------------------------------------------------------------------

function modifier_kobold_tunneler_prospecting_aura_omg:IsHidden()               return true end
function modifier_kobold_tunneler_prospecting_aura_omg:IsPurgable() 		    return false end
function modifier_kobold_tunneler_prospecting_aura_omg:RemoveOnDeath()	        return false end
function modifier_kobold_tunneler_prospecting_aura_omg:IsAura()	                return not self:GetParent():PassivesDisabled() end
function modifier_kobold_tunneler_prospecting_aura_omg:GetAuraRadius()	        return self.radius end
function modifier_kobold_tunneler_prospecting_aura_omg:GetAuraSearchTeam()      return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_kobold_tunneler_prospecting_aura_omg:GetAuraSearchType()      return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_kobold_tunneler_prospecting_aura_omg:GetAuraSearchFlags()     return 0 end
function modifier_kobold_tunneler_prospecting_aura_omg:GetModifierAura()        return "modifier_kobold_tunneler_prospecting_aura_bonus_omg" end
function modifier_kobold_tunneler_prospecting_aura_omg:GetTexture()             return "kobold_tunneler_prospecting" end

--------------------------------------------------------------------------------

function modifier_kobold_tunneler_prospecting_aura_omg:OnCreated(kv)
    if not IsServer() then return end
    self.radius = GetAbilitySpecial("kobold_tunneler_prospecting", "radius")
end

--------------------------------------------------------------------------------

modifier_kobold_tunneler_prospecting_aura_bonus_omg = class({})

--------------------------------------------------------------------------------

function modifier_kobold_tunneler_prospecting_aura_bonus_omg:IsPurgable()       return false end
function modifier_kobold_tunneler_prospecting_aura_bonus_omg:GetTexture()       return "kobold_tunneler_prospecting" end

--------------------------------------------------------------------------------

function modifier_kobold_tunneler_prospecting_aura_bonus_omg:OnCreated(kv)
    if not IsServer() then return end
    self.gpm_aura = GetAbilitySpecial("kobold_tunneler_prospecting", "gpm_aura")

    self:StartIntervalThink(60 / self.gpm_aura)
    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_kobold_tunneler_prospecting_aura_bonus_omg:AddCustomTransmitterData()
	return {gpm_aura = self.gpm_aura}
end

--------------------------------------------------------------------------------

function modifier_kobold_tunneler_prospecting_aura_bonus_omg:HandleCustomTransmitterData(data)
	self.gpm_aura = data.gpm_aura
end

--------------------------------------------------------------------------------

function modifier_kobold_tunneler_prospecting_aura_bonus_omg:OnIntervalThink()
    self:GetParent():ModifyGold(1, true, DOTA_ModifyGold_AbilityGold)
end

--------------------------------------------------------------------------------

function modifier_kobold_tunneler_prospecting_aura_bonus_omg:DeclareFunctions()
    return {MODIFIER_PROPERTY_TOOLTIP}
end

--------------------------------------------------------------------------------

function modifier_kobold_tunneler_prospecting_aura_bonus_omg:OnTooltip()
    return self.gpm_aura
end