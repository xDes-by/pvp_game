modifier_satyr_hellcaller_unholy_aura_omg = modifier_satyr_hellcaller_unholy_aura_omg or class({})

--------------------------------------------------------------------------------

function modifier_satyr_hellcaller_unholy_aura_omg:IsHidden()               return true end
function modifier_satyr_hellcaller_unholy_aura_omg:IsPurgable() 	        return false end
function modifier_satyr_hellcaller_unholy_aura_omg:RemoveOnDeath()	        return false end
function modifier_satyr_hellcaller_unholy_aura_omg:IsAura()	                return not self:GetParent():PassivesDisabled() end
function modifier_satyr_hellcaller_unholy_aura_omg:GetAuraRadius()	        return self.radius end
function modifier_satyr_hellcaller_unholy_aura_omg:GetAuraSearchTeam()      return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_satyr_hellcaller_unholy_aura_omg:GetAuraSearchType()      return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_satyr_hellcaller_unholy_aura_omg:GetAuraSearchFlags()     return 0 end
function modifier_satyr_hellcaller_unholy_aura_omg:GetModifierAura()        return "modifier_satyr_hellcaller_unholy_aura_bonus_omg" end
function modifier_satyr_hellcaller_unholy_aura_omg:GetTexture()             return "satyr_hellcaller_unholy_aura" end

--------------------------------------------------------------------------------

function modifier_satyr_hellcaller_unholy_aura_omg:OnCreated(kv)
    if not IsServer() then return end
    self.radius = GetAbilitySpecial("satyr_hellcaller_unholy_aura", "radius")
end

--------------------------------------------------------------------------------

modifier_satyr_hellcaller_unholy_aura_bonus_omg = class({})

--------------------------------------------------------------------------------

function modifier_satyr_hellcaller_unholy_aura_bonus_omg:IsPurgable()       return false end
function modifier_satyr_hellcaller_unholy_aura_bonus_omg:GetTexture()       return "satyr_hellcaller_unholy_aura" end

--------------------------------------------------------------------------------

function modifier_satyr_hellcaller_unholy_aura_bonus_omg:OnCreated(kv)
    if not IsServer() then return end
    self.health_regen = GetAbilitySpecial("satyr_hellcaller_unholy_aura", "health_regen")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_satyr_hellcaller_unholy_aura_bonus_omg:AddCustomTransmitterData()
	return {health_regen = self.health_regen}
end

--------------------------------------------------------------------------------

function modifier_satyr_hellcaller_unholy_aura_bonus_omg:HandleCustomTransmitterData(data)
	self.health_regen = data.health_regen
end

--------------------------------------------------------------------------------

function modifier_satyr_hellcaller_unholy_aura_bonus_omg:DeclareFunctions()
    return {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT}
end

--------------------------------------------------------------------------------

function modifier_satyr_hellcaller_unholy_aura_bonus_omg:GetModifierConstantHealthRegen()
    return self.health_regen
end