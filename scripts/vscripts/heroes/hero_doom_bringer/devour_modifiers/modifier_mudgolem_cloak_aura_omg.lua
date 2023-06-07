modifier_mudgolem_cloak_aura_omg = modifier_mudgolem_cloak_aura_omg or class({})

--------------------------------------------------------------------------------

function modifier_mudgolem_cloak_aura_omg:IsHidden()            return true end
function modifier_mudgolem_cloak_aura_omg:IsPurgable() 		    return false end
function modifier_mudgolem_cloak_aura_omg:RemoveOnDeath()	    return false end
function modifier_mudgolem_cloak_aura_omg:IsAura()	            return not self:GetParent():PassivesDisabled() end
function modifier_mudgolem_cloak_aura_omg:GetAuraRadius()	    return self.radius end
function modifier_mudgolem_cloak_aura_omg:GetAuraSearchTeam()   return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_mudgolem_cloak_aura_omg:GetAuraSearchType()   return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_mudgolem_cloak_aura_omg:GetAuraSearchFlags()  return 0 end
function modifier_mudgolem_cloak_aura_omg:GetModifierAura()     return "modifier_mudgolem_cloak_aura_bonus_omg" end
function modifier_mudgolem_cloak_aura_omg:GetTexture()          return "mudgolem_cloak_aura" end

--------------------------------------------------------------------------------

function modifier_mudgolem_cloak_aura_omg:OnCreated(kv)
    if not IsServer() then return end
    self.radius = GetAbilitySpecial("mudgolem_cloak_aura", "radius")
end

--------------------------------------------------------------------------------

modifier_mudgolem_cloak_aura_bonus_omg = class({})

--------------------------------------------------------------------------------

function modifier_mudgolem_cloak_aura_bonus_omg:IsPurgable()       return false end
function modifier_mudgolem_cloak_aura_bonus_omg:GetTexture()       return "mudgolem_cloak_aura" end

--------------------------------------------------------------------------------

function modifier_mudgolem_cloak_aura_bonus_omg:OnCreated(kv)
    if not IsServer() then return end
    self.bonus_magical_armor = GetAbilitySpecial("mudgolem_cloak_aura", "bonus_magical_armor_creeps")

    if self:GetParent():IsConsideredHero() then
        self.bonus_magical_armor = GetAbilitySpecial("mudgolem_cloak_aura", "bonus_magical_armor")
    end

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_mudgolem_cloak_aura_bonus_omg:AddCustomTransmitterData()
	return {bonus_magical_armor = self.bonus_magical_armor}
end

--------------------------------------------------------------------------------

function modifier_mudgolem_cloak_aura_bonus_omg:HandleCustomTransmitterData(data)
	self.bonus_magical_armor = data.bonus_magical_armor
end

--------------------------------------------------------------------------------

function modifier_mudgolem_cloak_aura_bonus_omg:DeclareFunctions()
    return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
end

--------------------------------------------------------------------------------

function modifier_mudgolem_cloak_aura_bonus_omg:GetModifierMagicalResistanceBonus()
    return self.bonus_magical_armor
end