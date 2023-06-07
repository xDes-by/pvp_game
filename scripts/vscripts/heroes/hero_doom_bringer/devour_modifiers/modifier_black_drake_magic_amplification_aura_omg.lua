modifier_black_drake_magic_amplification_aura_omg = modifier_black_drake_magic_amplification_aura_omg or class({})

--------------------------------------------------------------------------------

function modifier_black_drake_magic_amplification_aura_omg:IsPurgable() 		    return false end
function modifier_black_drake_magic_amplification_aura_omg:RemoveOnDeath()	        return false end
function modifier_black_drake_magic_amplification_aura_omg:IsAura()	                return not self:GetParent():PassivesDisabled() end
function modifier_black_drake_magic_amplification_aura_omg:GetAuraRadius()	        return self.radius end
function modifier_black_drake_magic_amplification_aura_omg:GetAuraSearchTeam()      return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_black_drake_magic_amplification_aura_omg:GetAuraSearchType()      return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_black_drake_magic_amplification_aura_omg:GetAuraSearchFlags()     return 0 end
function modifier_black_drake_magic_amplification_aura_omg:GetModifierAura()        return "modifier_black_drake_magic_amplification_aura_bonus_omg" end
function modifier_black_drake_magic_amplification_aura_omg:GetTexture()             return "black_drake_magic_amplification_aura" end

--------------------------------------------------------------------------------

function modifier_black_drake_magic_amplification_aura_omg:OnCreated(kv)
    if not IsServer() then return end
    self.radius = GetAbilitySpecial("black_drake_magic_amplification_aura", "radius")
end

--------------------------------------------------------------------------------

modifier_black_drake_magic_amplification_aura_bonus_omg = class({})

--------------------------------------------------------------------------------

function modifier_black_drake_magic_amplification_aura_bonus_omg:IsPurgable()       return false end
function modifier_black_drake_magic_amplification_aura_bonus_omg:GetTexture()       return "black_drake_magic_amplification_aura" end

--------------------------------------------------------------------------------

function modifier_black_drake_magic_amplification_aura_bonus_omg:OnCreated(kv)
    if not IsServer() then return end
    self.spell_amp = GetAbilitySpecial("black_drake_magic_amplification_aura", "spell_amp")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_black_drake_magic_amplification_aura_bonus_omg:AddCustomTransmitterData()
	return {spell_amp = self.spell_amp}
end

--------------------------------------------------------------------------------

function modifier_black_drake_magic_amplification_aura_bonus_omg:HandleCustomTransmitterData(data)
	self.spell_amp = data.spell_amp
end

--------------------------------------------------------------------------------

function modifier_black_drake_magic_amplification_aura_bonus_omg:DeclareFunctions()
    return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end

--------------------------------------------------------------------------------

function modifier_black_drake_magic_amplification_aura_bonus_omg:GetModifierIncomingDamage_Percentage(params)
    if IsClient() then
        return self.spell_amp --Tooltip
    else
        local damage_category = params.damage_category

        if damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
            return self.spell_amp
        end

        return 0
    end
end