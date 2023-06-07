modifier_alpha_wolf_critical_strike_omg = modifier_alpha_wolf_critical_strike_omg or class({})

--------------------------------------------------------------------------------

function modifier_alpha_wolf_critical_strike_omg:IsPurgable()       return false end
function modifier_alpha_wolf_critical_strike_omg:RemoveOnDeath()    return false end
function modifier_alpha_wolf_critical_strike_omg:GetTexture()       return "alpha_wolf_critical_strike" end

--------------------------------------------------------------------------------

function modifier_alpha_wolf_critical_strike_omg:OnCreated(kv)
    if not IsServer() then return end
    self.crit_chance = GetAbilitySpecial("alpha_wolf_critical_strike", "crit_chance")
    self.crit_mult = GetAbilitySpecial("alpha_wolf_critical_strike", "crit_mult")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_alpha_wolf_critical_strike_omg:AddCustomTransmitterData()
	return {
        crit_chance = self.crit_chance,
        crit_mult = self.crit_mult,
    }
end

--------------------------------------------------------------------------------

function modifier_alpha_wolf_critical_strike_omg:HandleCustomTransmitterData(data)
	self.crit_chance = data.crit_chance
    self.crit_mult = data.crit_mult
end

--------------------------------------------------------------------------------

function modifier_alpha_wolf_critical_strike_omg:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2
    }
end

--------------------------------------------------------------------------------

function modifier_alpha_wolf_critical_strike_omg:GetModifierPreAttack_CriticalStrike(params)
    if not IsServer() then return end

    local attacker = params.attacker
    local target = params.target

    if not attacker or attacker ~= self:GetParent() or not target then
        return 0
    end

    if attacker:PassivesDisabled() or target:IsBuilding() or target:IsOther() or target:GetTeamNumber() == attacker:GetTeamNumber() then
        return 0
    end

    if not RollPseudoRandomPercentage(self.crit_chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, attacker) then
        return 0
    end

    return self.crit_mult
end

--------------------------------------------------------------------------------

function modifier_alpha_wolf_critical_strike_omg:OnTooltip()
    return self.crit_chance
end

--------------------------------------------------------------------------------

function modifier_alpha_wolf_critical_strike_omg:OnTooltip2()
    return self.crit_mult
end