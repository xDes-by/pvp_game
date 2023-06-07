modifier_gnoll_assassin_envenomed_weapon_omg = modifier_gnoll_assassin_envenomed_weapon_omg or class({})

--------------------------------------------------------------------------------

function modifier_gnoll_assassin_envenomed_weapon_omg:IsPurgable()       return false end
function modifier_gnoll_assassin_envenomed_weapon_omg:RemoveOnDeath()    return false end
function modifier_gnoll_assassin_envenomed_weapon_omg:GetTexture()       return "gnoll_assassin_envenomed_weapon" end

--------------------------------------------------------------------------------

function modifier_gnoll_assassin_envenomed_weapon_omg:OnCreated(kv)
    if not IsServer() then return end
    self.hero_duration = GetAbilitySpecial("gnoll_assassin_envenomed_weapon", "hero_duration")
    self.non_hero_duration = GetAbilitySpecial("gnoll_assassin_envenomed_weapon", "non_hero_duration")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_gnoll_assassin_envenomed_weapon_omg:AddCustomTransmitterData()
	return {
        hero_duration = self.hero_duration,
        non_hero_duration = self.non_hero_duration,
    }
end

--------------------------------------------------------------------------------

function modifier_gnoll_assassin_envenomed_weapon_omg:HandleCustomTransmitterData(data)
	self.hero_duration = data.hero_duration
    self.non_hero_duration = data.non_hero_duration
end

--------------------------------------------------------------------------------

function modifier_gnoll_assassin_envenomed_weapon_omg:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2
    }
end

--------------------------------------------------------------------------------

function modifier_gnoll_assassin_envenomed_weapon_omg:OnAttackLanded(params)
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

    local duration = target:IsHero() and self.hero_duration or self.non_hero_duration

    target:AddNewModifier(attacker, self:GetAbility(), "modifier_gnoll_assassin_envenomed_weapon_poison_omg", {duration = duration})
end

--------------------------------------------------------------------------------

function modifier_gnoll_assassin_envenomed_weapon_omg:OnTooltip()
    return self.non_hero_duration
end

--------------------------------------------------------------------------------

function modifier_gnoll_assassin_envenomed_weapon_omg:OnTooltip2()
    return self.hero_duration
end

--------------------------------------------------------------------------------

modifier_gnoll_assassin_envenomed_weapon_poison_omg = modifier_gnoll_assassin_envenomed_weapon_poison_omg or class({})

--------------------------------------------------------------------------------

function modifier_gnoll_assassin_envenomed_weapon_poison_omg:IsPurgable()   return true end
function modifier_gnoll_assassin_envenomed_weapon_poison_omg:GetTexture()   return "gnoll_assassin_envenomed_weapon" end

--------------------------------------------------------------------------------

function modifier_gnoll_assassin_envenomed_weapon_poison_omg:OnCreated(kv)
    if not IsServer() then return end
    self.regen_reduction = -GetAbilitySpecial("gnoll_assassin_envenomed_weapon", "regen_reduction")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_gnoll_assassin_envenomed_weapon_poison_omg:AddCustomTransmitterData()
	return {regen_reduction = self.regen_reduction }
end

--------------------------------------------------------------------------------

function modifier_gnoll_assassin_envenomed_weapon_poison_omg:HandleCustomTransmitterData(data)
	self.regen_reduction = data.regen_reduction
end

--------------------------------------------------------------------------------

function modifier_gnoll_assassin_envenomed_weapon_poison_omg:DeclareFunctions()
    return {MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE}
end

--------------------------------------------------------------------------------

function modifier_gnoll_assassin_envenomed_weapon_poison_omg:GetModifierHPRegenAmplify_Percentage()
    return self.regen_reduction
end
 