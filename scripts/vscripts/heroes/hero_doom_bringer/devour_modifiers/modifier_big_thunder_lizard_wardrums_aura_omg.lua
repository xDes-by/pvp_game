modifier_big_thunder_lizard_wardrums_aura_omg = modifier_big_thunder_lizard_wardrums_aura_omg or class({})

--------------------------------------------------------------------------------

function modifier_big_thunder_lizard_wardrums_aura_omg:IsHidden()               return true end
function modifier_big_thunder_lizard_wardrums_aura_omg:IsPurgable() 		    return false end
function modifier_big_thunder_lizard_wardrums_aura_omg:RemoveOnDeath()	        return false end
function modifier_big_thunder_lizard_wardrums_aura_omg:IsAura()	                return not self:GetParent():PassivesDisabled() end
function modifier_big_thunder_lizard_wardrums_aura_omg:GetAuraRadius()	        return self.radius end
function modifier_big_thunder_lizard_wardrums_aura_omg:GetAuraSearchTeam()      return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_big_thunder_lizard_wardrums_aura_omg:GetAuraSearchType()      return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_big_thunder_lizard_wardrums_aura_omg:GetAuraSearchFlags()     return 0 end
function modifier_big_thunder_lizard_wardrums_aura_omg:GetModifierAura()        return "modifier_big_thunder_lizard_wardrums_aura_bonus_omg" end
function modifier_big_thunder_lizard_wardrums_aura_omg:GetTexture()             return "big_thunder_lizard_wardrums_aura" end

--------------------------------------------------------------------------------

function modifier_big_thunder_lizard_wardrums_aura_omg:OnCreated(kv)
    if not IsServer() then return end
    self.radius = GetAbilitySpecial("big_thunder_lizard_wardrums_aura", "radius")
end

--------------------------------------------------------------------------------

modifier_big_thunder_lizard_wardrums_aura_bonus_omg = class({})

--------------------------------------------------------------------------------

function modifier_big_thunder_lizard_wardrums_aura_bonus_omg:IsPurgable()       return false end
function modifier_big_thunder_lizard_wardrums_aura_bonus_omg:GetTexture()       return "big_thunder_lizard_wardrums_aura" end

--------------------------------------------------------------------------------

function modifier_big_thunder_lizard_wardrums_aura_bonus_omg:OnCreated(kv)
    if not IsServer() then return end
    self.speed_bonus = GetAbilitySpecial("big_thunder_lizard_wardrums_aura", "speed_bonus")
    self.accuracy = GetAbilitySpecial("big_thunder_lizard_wardrums_aura", "accuracy")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_big_thunder_lizard_wardrums_aura_bonus_omg:AddCustomTransmitterData()
	return {
        speed_bonus = self.speed_bonus,
        accuracy = self.accuracy
    }
end

--------------------------------------------------------------------------------

function modifier_big_thunder_lizard_wardrums_aura_bonus_omg:HandleCustomTransmitterData(data)
	self.speed_bonus = data.speed_bonus
    self.accuracy = data.accuracy
end

--------------------------------------------------------------------------------

function modifier_big_thunder_lizard_wardrums_aura_bonus_omg:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_TOOLTIP
    }
end

--------------------------------------------------------------------------------

function modifier_big_thunder_lizard_wardrums_aura_bonus_omg:OnAttackStart(params)
    if not IsServer() or self:GetParent() ~= params.attacker then return end

    self.cannot_miss = RollPercentage(self.accuracy)
end

--------------------------------------------------------------------------------

function modifier_big_thunder_lizard_wardrums_aura_bonus_omg:CheckState()
    return {[MODIFIER_STATE_CANNOT_MISS] = self.cannot_miss}
end

--------------------------------------------------------------------------------

function modifier_big_thunder_lizard_wardrums_aura_bonus_omg:GetModifierAttackSpeedBonus_Constant()
    return self.speed_bonus
end

--------------------------------------------------------------------------------

function modifier_big_thunder_lizard_wardrums_aura_bonus_omg:OnTooltip()
    return self.accuracy
end