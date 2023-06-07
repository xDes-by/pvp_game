modifier_black_dragon_splash_attack_omg = modifier_black_dragon_splash_attack_omg or class({})

--------------------------------------------------------------------------------

function modifier_black_dragon_splash_attack_omg:IsPurgable()       return false end
function modifier_black_dragon_splash_attack_omg:RemoveOnDeath()    return false end
function modifier_black_dragon_splash_attack_omg:GetTexture()       return "black_dragon_splash_attack" end

--------------------------------------------------------------------------------

function modifier_black_dragon_splash_attack_omg:OnCreated(kv)
    if not IsServer() then return end
    self.range = GetAbilitySpecial("black_dragon_splash_attack", "range")
    self.damage_percent = GetAbilitySpecial("black_dragon_splash_attack", "damage_percent")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_black_dragon_splash_attack_omg:AddCustomTransmitterData()
	return {
        range = self.range,
        damage_percent = self.damage_percent,
    }
end

--------------------------------------------------------------------------------

function modifier_black_dragon_splash_attack_omg:HandleCustomTransmitterData(data)
	self.range = data.range
    self.damage_percent = data.damage_percent
end

--------------------------------------------------------------------------------

function modifier_black_dragon_splash_attack_omg:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2
    }
end

--------------------------------------------------------------------------------

function modifier_black_dragon_splash_attack_omg:OnAttackLanded(params)
    if not IsServer() then return end

    local attacker = params.attacker
    local target = params.target
    local ability = self:GetAbility()

    if not attacker or not target or not ability or ability:IsNull() then
        return 0
    end

    if attacker ~= self:GetParent() or attacker:PassivesDisabled() or attacker:IsIllusion() then
        return 0
    end

    if target:IsBuilding() or target:IsOther() or target:IsMagicImmune() then
        return 0
    end

    local damage_table = {
        victim = nil,
        attacker = attacker,
        damage = params.damage * self.damage_percent / 100,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = ability
    }

    local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
    for _, enemy in pairs(enemies) do
        if enemy ~= target then
            damage_table.victim = enemy
            ApplyDamage(damage_table)
        end
    end
end

--------------------------------------------------------------------------------

function modifier_black_dragon_splash_attack_omg:OnTooltip()
    return self.damage_percent
end

--------------------------------------------------------------------------------

function modifier_black_dragon_splash_attack_omg:OnTooltip2()
    return self.range
end