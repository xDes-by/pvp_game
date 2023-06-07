modifier_kobold_disarm_omg = modifier_kobold_disarm_omg or class({})

--------------------------------------------------------------------------------

function modifier_kobold_disarm_omg:IsPurgable()       return false end
function modifier_kobold_disarm_omg:RemoveOnDeath()    return false end
function modifier_kobold_disarm_omg:GetTexture()       return "kobold_disarm" end

--------------------------------------------------------------------------------

function modifier_kobold_disarm_omg:OnCreated(kv)
    if not IsServer() then return end
    self.duration = GetAbilitySpecial("kobold_disarm", "duration")
    self.needed_attacks = 3 -- not present in KV
    self.cooldown = GetAbilityKeyValuesByName("kobold_disarm")["AbilityCooldown"]

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_kobold_disarm_omg:AddCustomTransmitterData()
	return {
        needed_attacks = self.needed_attacks,
        duration = self.duration
    }
end

--------------------------------------------------------------------------------

function modifier_kobold_disarm_omg:HandleCustomTransmitterData(data)
	self.needed_attacks = data.needed_attacks
    self.duration = data.duration
end

--------------------------------------------------------------------------------

function modifier_kobold_disarm_omg:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2
    }
end

--------------------------------------------------------------------------------

function modifier_kobold_disarm_omg:OnAttackLanded(params)
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

    if attacker:HasModifier("modifier_kobold_disarm_cooldown_omg") then
        return 0
    end

    if self:GetStackCount() >= self.needed_attacks - 1 then
        target:AddNewModifier(attacker, self:GetAbility(), "modifier_disarmed", {duration = self.duration}) --TODO: custom disarm to display FX
        attacker:AddNewModifier(attacker, ability, "modifier_kobold_disarm_cooldown_omg", {duration = self.cooldown * (1 - target:GetStatusResistance())})
        
        self:SetStackCount(0)
    else
        self:IncrementStackCount()
    end
end

--------------------------------------------------------------------------------

function modifier_kobold_disarm_omg:OnTooltip()
    return self.duration
end

--------------------------------------------------------------------------------

function modifier_kobold_disarm_omg:OnTooltip2()
    return self.needed_attacks
end


--------------------------------------------------------------------------------

modifier_kobold_disarm_cooldown_omg = modifier_kobold_disarm_cooldown_omg or class({})

--------------------------------------------------------------------------------

function modifier_kobold_disarm_cooldown_omg:IsPurgable()       return false end
function modifier_kobold_disarm_cooldown_omg:RemoveOnDeath()    return false end
function modifier_kobold_disarm_cooldown_omg:GetTexture()       return "kobold_disarm" end