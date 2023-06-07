modifier_furbolg_enrage_damage_omg = modifier_furbolg_enrage_damage_omg or class({})

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_damage_omg:IsPurgable()       return false end
function modifier_furbolg_enrage_damage_omg:RemoveOnDeath()    return false end
function modifier_furbolg_enrage_damage_omg:GetTexture()       return "furbolg_enrage_damage" end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_damage_omg:OnCreated(kv)
    if not IsServer() then return end
    self.duration = GetAbilitySpecial("furbolg_enrage_damage", "duration")
    self.radius = GetAbilitySpecial("furbolg_enrage_damage", "radius")
    self.bonus_dmg_pct = GetAbilitySpecial("furbolg_enrage_damage", "bonus_dmg_pct")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_damage_omg:AddCustomTransmitterData()
	return {
        duration = self.duration,
        radius = self.radius,
        bonus_dmg_pct = self.bonus_dmg_pct
    }
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_damage_omg:HandleCustomTransmitterData(data)
	self.duration = data.duration
    self.radius = data.radius
    self.bonus_dmg_pct = data.bonus_dmg_pct
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_damage_omg:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2
    }
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_damage_omg:OnDeath(params)
    if not IsServer() then return end

    local unit = params.unit
    local ability = self:GetAbility()

    if not unit or not ability or ability:IsNull() then
        return 0
    end

    if unit ~= self:GetParent() or unit:PassivesDisabled() or unit:IsIllusion() then
        return 0
    end

    ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticle("particles/neutral_fx/hellbear_rush_cast.vpcf", PATTACH_ABSORIGIN, unit))

    local allies = FindUnitsInRadius(unit:GetTeamNumber(), unit:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
    for _, ally in pairs(allies) do
        ally:AddNewModifier(unit, ability, "modifier_furbolg_enrage_damage_bonus_omg", {duration = self.duration})
    end
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_damage_omg:OnTooltip()
    return self.bonus_dmg_pct
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_damage_omg:OnTooltip2()
    return self.duration
end

--------------------------------------------------------------------------------

modifier_furbolg_enrage_damage_bonus_omg = modifier_furbolg_enrage_damage_bonus_omg or class({})

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_damage_bonus_omg:IsPurgable()   return true end
function modifier_furbolg_enrage_damage_bonus_omg:GetTexture()   return "furbolg_enrage_damage" end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_damage_bonus_omg:OnCreated(kv)
    if not IsServer() then return end
    self.bonus_dmg_pct = GetAbilitySpecial("furbolg_enrage_damage", "bonus_dmg_pct")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_damage_bonus_omg:AddCustomTransmitterData()
	return {bonus_dmg_pct = self.bonus_dmg_pct }
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_damage_bonus_omg:HandleCustomTransmitterData(data)
	self.bonus_dmg_pct = data.bonus_dmg_pct
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_damage_bonus_omg:DeclareFunctions()
    return {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE}
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_damage_bonus_omg:GetModifierBaseDamageOutgoing_Percentage()
    return self.bonus_dmg_pct
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_damage_bonus_omg:GetEffectName()
    return "particles/neutral_fx/hellbear_power.vpcf"
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_damage_bonus_omg:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
 