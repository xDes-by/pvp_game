modifier_granite_golem_hp_aura_omg = modifier_granite_golem_hp_aura_omg or class({})

--------------------------------------------------------------------------------

function modifier_granite_golem_hp_aura_omg:IsHidden()              return true end
function modifier_granite_golem_hp_aura_omg:IsPurgable() 		    return false end
function modifier_granite_golem_hp_aura_omg:RemoveOnDeath()	        return false end
function modifier_granite_golem_hp_aura_omg:IsAura()	            return true end
function modifier_granite_golem_hp_aura_omg:GetAuraRadius()	        return self.radius end
function modifier_granite_golem_hp_aura_omg:GetAuraSearchTeam()     return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_granite_golem_hp_aura_omg:GetAuraSearchType()     return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_granite_golem_hp_aura_omg:GetAuraSearchFlags()    return 0 end
function modifier_granite_golem_hp_aura_omg:GetModifierAura()       return "modifier_granite_golem_hp_aura_bonus_omg" end
function modifier_granite_golem_hp_aura_omg:GetTexture()            return "granite_golem_hp_aura" end

--------------------------------------------------------------------------------

function modifier_granite_golem_hp_aura_omg:OnCreated(kv)
    if not IsServer() then return end
    self.radius = GetAbilitySpecial("granite_golem_hp_aura", "radius")
end

--------------------------------------------------------------------------------

modifier_granite_golem_hp_aura_bonus_omg = class({})

--------------------------------------------------------------------------------

function modifier_granite_golem_hp_aura_bonus_omg:IsPurgable()       return false end
function modifier_granite_golem_hp_aura_bonus_omg:GetTexture()       return "granite_golem_hp_aura" end

--------------------------------------------------------------------------------

function modifier_granite_golem_hp_aura_bonus_omg:OnCreated(kv)
    if not IsServer() then return end
    self.bonus_hp = GetAbilitySpecial("granite_golem_hp_aura", "bonus_hp")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_granite_golem_hp_aura_bonus_omg:AddCustomTransmitterData()
	return {bonus_hp = self.bonus_hp}
end

--------------------------------------------------------------------------------

function modifier_granite_golem_hp_aura_bonus_omg:HandleCustomTransmitterData(data)
	self.bonus_hp = data.bonus_hp
end

--------------------------------------------------------------------------------

function modifier_granite_golem_hp_aura_bonus_omg:DeclareFunctions()
    return {MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE}
end

--------------------------------------------------------------------------------

function modifier_granite_golem_hp_aura_bonus_omg:GetModifierExtraHealthPercentage()
    return self.bonus_hp
end