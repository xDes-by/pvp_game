modifier_frostbitten_golem_time_warp_aura_omg = modifier_frostbitten_golem_time_warp_aura_omg or class({})

--------------------------------------------------------------------------------

function modifier_frostbitten_golem_time_warp_aura_omg:IsHidden()               return true end
function modifier_frostbitten_golem_time_warp_aura_omg:IsPurgable() 		    return false end
function modifier_frostbitten_golem_time_warp_aura_omg:RemoveOnDeath()	        return false end
function modifier_frostbitten_golem_time_warp_aura_omg:IsAura()	                return not self:GetParent():PassivesDisabled() end
function modifier_frostbitten_golem_time_warp_aura_omg:GetAuraRadius()	        return self.radius end
function modifier_frostbitten_golem_time_warp_aura_omg:GetAuraSearchTeam()      return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_frostbitten_golem_time_warp_aura_omg:GetAuraSearchType()      return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_frostbitten_golem_time_warp_aura_omg:GetAuraSearchFlags()     return 0 end
function modifier_frostbitten_golem_time_warp_aura_omg:GetModifierAura()        return "modifier_frostbitten_golem_time_warp_aura_bonus_omg" end
function modifier_frostbitten_golem_time_warp_aura_omg:GetTexture()             return "frostbitten_golem_time_warp_aura" end

--------------------------------------------------------------------------------

function modifier_frostbitten_golem_time_warp_aura_omg:OnCreated(kv)
    if not IsServer() then return end
    self.radius = GetAbilitySpecial("frostbitten_golem_time_warp_aura", "radius")
end

--------------------------------------------------------------------------------

modifier_frostbitten_golem_time_warp_aura_bonus_omg = class({})

--------------------------------------------------------------------------------

function modifier_frostbitten_golem_time_warp_aura_bonus_omg:IsPurgable()       return false end
function modifier_frostbitten_golem_time_warp_aura_bonus_omg:GetTexture()       return "frostbitten_golem_time_warp_aura" end

--------------------------------------------------------------------------------

function modifier_frostbitten_golem_time_warp_aura_bonus_omg:OnCreated(kv)
    if not IsServer() then return end
    self.bonus_cdr = GetAbilitySpecial("frostbitten_golem_time_warp_aura", "bonus_cdr")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_frostbitten_golem_time_warp_aura_bonus_omg:AddCustomTransmitterData()
	return {bonus_cdr = self.bonus_cdr}
end

--------------------------------------------------------------------------------

function modifier_frostbitten_golem_time_warp_aura_bonus_omg:HandleCustomTransmitterData(data)
	self.bonus_cdr = data.bonus_cdr
end

--------------------------------------------------------------------------------

function modifier_frostbitten_golem_time_warp_aura_bonus_omg:DeclareFunctions()
    return {MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE}
end

--------------------------------------------------------------------------------

function modifier_frostbitten_golem_time_warp_aura_bonus_omg:GetModifierPercentageCooldown()
    return self.bonus_cdr
end