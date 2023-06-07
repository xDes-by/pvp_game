modifier_furbolg_enrage_attack_speed_omg = modifier_furbolg_enrage_attack_speed_omg or class({})

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_attack_speed_omg:IsPurgable()       return false end
function modifier_furbolg_enrage_attack_speed_omg:RemoveOnDeath()    return false end
function modifier_furbolg_enrage_attack_speed_omg:GetTexture()       return "furbolg_enrage_attack_speed" end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_attack_speed_omg:OnCreated(kv)
    if not IsServer() then return end
    self.duration = GetAbilitySpecial("furbolg_enrage_attack_speed", "duration")
    self.bonus_aspd = GetAbilitySpecial("furbolg_enrage_attack_speed", "bonus_aspd")
    self.radius = GetAbilitySpecial("furbolg_enrage_attack_speed", "radius")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_attack_speed_omg:AddCustomTransmitterData()
	return {
        bonus_aspd = self.bonus_aspd,
        duration = self.duration,
    }
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_attack_speed_omg:HandleCustomTransmitterData(data)
	self.bonus_aspd = data.bonus_aspd
    self.duration = data.duration
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_attack_speed_omg:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2
    }
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_attack_speed_omg:OnDeath(params)
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
        ally:AddNewModifier(unit, ability, "modifier_furbolg_enrage_attack_speed_bonus_omg", {duration = self.duration})
    end
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_attack_speed_omg:OnTooltip()
    return self.bonus_aspd
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_attack_speed_omg:OnTooltip2()
    return self.duration
end

--------------------------------------------------------------------------------

modifier_furbolg_enrage_attack_speed_bonus_omg = modifier_furbolg_enrage_attack_speed_bonus_omg or class({})

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_attack_speed_bonus_omg:IsPurgable()   return true end
function modifier_furbolg_enrage_attack_speed_bonus_omg:GetTexture()   return "furbolg_enrage_attack_speed" end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_attack_speed_bonus_omg:OnCreated(kv)
    if not IsServer() then return end
    self.bonus_aspd = GetAbilitySpecial("furbolg_enrage_attack_speed", "bonus_aspd")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_attack_speed_bonus_omg:AddCustomTransmitterData()
	return {bonus_aspd = self.bonus_aspd }
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_attack_speed_bonus_omg:HandleCustomTransmitterData(data)
	self.bonus_aspd = data.bonus_aspd
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_attack_speed_bonus_omg:DeclareFunctions()
    return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_attack_speed_bonus_omg:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_aspd
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_attack_speed_bonus_omg:GetEffectName()
    return "particles/neutral_fx/hellbear_rush.vpcf"
end

--------------------------------------------------------------------------------

function modifier_furbolg_enrage_attack_speed_bonus_omg:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
 