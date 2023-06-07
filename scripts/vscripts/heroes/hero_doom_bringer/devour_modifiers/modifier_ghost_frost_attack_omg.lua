modifier_ghost_frost_attack_omg = modifier_ghost_frost_attack_omg or class({})

--------------------------------------------------------------------------------

function modifier_ghost_frost_attack_omg:IsPurgable()       return false end
function modifier_ghost_frost_attack_omg:RemoveOnDeath()    return false end
function modifier_ghost_frost_attack_omg:GetTexture()       return "ghost_frost_attack" end

--------------------------------------------------------------------------------

function modifier_ghost_frost_attack_omg:OnCreated(kv)
    if not IsServer() then return end
    self.duration = GetAbilitySpecial("ghost_frost_attack", "duration")
    self.movespeed_slow = GetAbilitySpecial("ghost_frost_attack", "movespeed_slow")
    self.attackspeed_slow = GetAbilitySpecial("ghost_frost_attack", "attackspeed_slow")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_ghost_frost_attack_omg:AddCustomTransmitterData()
	return {
        movespeed_slow = self.movespeed_slow,
        attackspeed_slow = self.attackspeed_slow
    }
end

--------------------------------------------------------------------------------

function modifier_ghost_frost_attack_omg:HandleCustomTransmitterData(data)
	self.movespeed_slow = data.movespeed_slow
    self.attackspeed_slow = data.attackspeed_slow
end

--------------------------------------------------------------------------------

function modifier_ghost_frost_attack_omg:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2
    }
end

--------------------------------------------------------------------------------

function modifier_ghost_frost_attack_omg:OnAttackLanded(params)
    if not IsServer() then return end

    local attacker = params.attacker
    local target = params.target
    local ability = self:GetAbility()

    if not attacker or not target or not ability or ability:IsNull() then
        return 0
    end

    if attacker ~= self:GetParent() or attacker:PassivesDisabled() or target:IsBuilding() or target:IsMagicImmune() then
        return 0
    end

    target:AddNewModifier(attacker, self:GetAbility(), "modifier_ghost_frost_attack_slow_omg", {duration = self.duration * (1 - target:GetStatusResistance())})
end


--------------------------------------------------------------------------------

function modifier_ghost_frost_attack_omg:OnTooltip()
    return self.movespeed_slow
end

--------------------------------------------------------------------------------

function modifier_ghost_frost_attack_omg:OnTooltip2()
    return self.attackspeed_slow
end

--------------------------------------------------------------------------------

modifier_ghost_frost_attack_slow_omg = modifier_ghost_frost_attack_slow_omg or class({})

--------------------------------------------------------------------------------

function modifier_ghost_frost_attack_slow_omg:IsPurgable()   return true end
function modifier_ghost_frost_attack_slow_omg:GetTexture()   return "ghost_frost_attack" end

--------------------------------------------------------------------------------

function modifier_ghost_frost_attack_slow_omg:OnCreated(kv)
    if not IsServer() then return end
    self.movespeed_slow = GetAbilitySpecial("ghost_frost_attack", "movespeed_slow")
    self.attackspeed_slow = GetAbilitySpecial("ghost_frost_attack", "attackspeed_slow")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_ghost_frost_attack_slow_omg:AddCustomTransmitterData()
	return {
        movespeed_slow = self.movespeed_slow,
        attackspeed_slow = self.attackspeed_slow
    }
end

--------------------------------------------------------------------------------

function modifier_ghost_frost_attack_slow_omg:HandleCustomTransmitterData(data)
	self.movespeed_slow = data.movespeed_slow
    self.attackspeed_slow = data.attackspeed_slow
end

--------------------------------------------------------------------------------

function modifier_ghost_frost_attack_slow_omg:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end

--------------------------------------------------------------------------------

function modifier_ghost_frost_attack_slow_omg:GetModifierMoveSpeedBonus_Percentage()
    return self.movespeed_slow
end

--------------------------------------------------------------------------------

function modifier_ghost_frost_attack_slow_omg:GetModifierAttackSpeedBonus_Constant()
    return self.attackspeed_slow
end

--------------------------------------------------------------------------------

function modifier_ghost_frost_attack_slow_omg:GetStatusEffectName()
    return "particles/status_fx/status_effect_frost.vpcf"
end

--------------------------------------------------------------------------------

function modifier_ghost_frost_attack_slow_omg:StatusEffectPriority()
    return MODIFIER_PRIORITY_NORMAL
end