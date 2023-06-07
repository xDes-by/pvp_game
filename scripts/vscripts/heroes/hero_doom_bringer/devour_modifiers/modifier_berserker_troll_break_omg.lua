modifier_berserker_troll_break_omg = modifier_berserker_troll_break_omg or class({})

--------------------------------------------------------------------------------

function modifier_berserker_troll_break_omg:IsPurgable()       return false end
function modifier_berserker_troll_break_omg:RemoveOnDeath()    return false end
function modifier_berserker_troll_break_omg:GetTexture()       return "berserker_troll_break" end

--------------------------------------------------------------------------------

function modifier_berserker_troll_break_omg:OnCreated(kv)
    if not IsServer() then return end
    self.duration = GetAbilitySpecial("berserker_troll_break", "duration")
    self.needed_attacks = 3 -- not present in KV
    self.cooldown = GetAbilityKeyValuesByName("berserker_troll_break")["AbilityCooldown"]

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_berserker_troll_break_omg:AddCustomTransmitterData()
	return {
        duration = self.duration,
        needed_attacks = self.needed_attacks
    }
end

--------------------------------------------------------------------------------

function modifier_berserker_troll_break_omg:HandleCustomTransmitterData(data)
	self.duration = data.duration
    self.needed_attacks = data.needed_attacks
end

--------------------------------------------------------------------------------

function modifier_berserker_troll_break_omg:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2
    }
end

--------------------------------------------------------------------------------

function modifier_berserker_troll_break_omg:OnAttackLanded(params)
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

    if attacker:HasModifier("modifier_berserker_troll_break_cooldown_omg") then
        return 0
    end

    if self:GetStackCount() >= self.needed_attacks - 1 then
        target:AddNewModifier(attacker, ability, "modifier_break", {duration = self.duration})
        attacker:AddNewModifier(attacker, ability, "modifier_berserker_troll_break_cooldown_omg", {duration = self.cooldown * (1 - target:GetStatusResistance())})
        
        self:SetStackCount(0)
    else
        self:IncrementStackCount()
    end
end

--------------------------------------------------------------------------------

function modifier_berserker_troll_break_omg:OnTooltip()
    return self.needed_attacks
end

--------------------------------------------------------------------------------

function modifier_berserker_troll_break_omg:OnTooltip2()
    return self.duration
end


--------------------------------------------------------------------------------

modifier_berserker_troll_break_cooldown_omg = modifier_berserker_troll_break_cooldown_omg or class({})

--------------------------------------------------------------------------------

function modifier_berserker_troll_break_cooldown_omg:IsPurgable()       return false end
function modifier_berserker_troll_break_cooldown_omg:RemoveOnDeath()    return false end
function modifier_berserker_troll_break_cooldown_omg:GetTexture()       return "berserker_troll_break" end