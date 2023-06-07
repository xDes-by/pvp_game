modifier_ancient_rock_golem_weakening_aura_omg = modifier_ancient_rock_golem_weakening_aura_omg or class({})

--------------------------------------------------------------------------------

function modifier_ancient_rock_golem_weakening_aura_omg:IsPurgable() 		    return false end
function modifier_ancient_rock_golem_weakening_aura_omg:RemoveOnDeath()	        return false end
function modifier_ancient_rock_golem_weakening_aura_omg:IsAura()	            return not self:GetParent():PassivesDisabled() end
function modifier_ancient_rock_golem_weakening_aura_omg:GetAuraRadius()	        return self.radius end
function modifier_ancient_rock_golem_weakening_aura_omg:GetAuraSearchTeam()     return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_ancient_rock_golem_weakening_aura_omg:GetAuraSearchType()     return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_ancient_rock_golem_weakening_aura_omg:GetAuraSearchFlags()    return 0 end
function modifier_ancient_rock_golem_weakening_aura_omg:GetModifierAura()       return "modifier_ancient_rock_golem_weakening_aura_bonus_omg" end
function modifier_ancient_rock_golem_weakening_aura_omg:GetTexture()            return "ancient_rock_golem_weakening_aura" end

--------------------------------------------------------------------------------

function modifier_ancient_rock_golem_weakening_aura_omg:OnCreated(kv)
    if not IsServer() then return end
    self.radius = GetAbilitySpecial("ancient_rock_golem_weakening_aura", "radius")
    self.armor_reduction = GetAbilitySpecial("ancient_rock_golem_weakening_aura", "armor_reduction")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_ancient_rock_golem_weakening_aura_omg:AddCustomTransmitterData()
	return {armor_reduction = self.armor_reduction}
end

--------------------------------------------------------------------------------

function modifier_ancient_rock_golem_weakening_aura_omg:HandleCustomTransmitterData(data)
	self.armor_reduction = data.armor_reduction
end

--------------------------------------------------------------------------------

function modifier_ancient_rock_golem_weakening_aura_omg:DeclareFunctions()
    return {MODIFIER_PROPERTY_TOOLTIP}
end

--------------------------------------------------------------------------------

function modifier_ancient_rock_golem_weakening_aura_omg:OnTooltip()
    return self.armor_reduction
end

--------------------------------------------------------------------------------

modifier_ancient_rock_golem_weakening_aura_bonus_omg = class({})

--------------------------------------------------------------------------------

function modifier_ancient_rock_golem_weakening_aura_bonus_omg:IsPurgable()       return false end
function modifier_ancient_rock_golem_weakening_aura_bonus_omg:GetTexture()       return "ancient_rock_golem_weakening_aura" end

--------------------------------------------------------------------------------

function modifier_ancient_rock_golem_weakening_aura_bonus_omg:OnCreated(kv)
    if not IsServer() then return end
    self.armor_reduction = -GetAbilitySpecial("ancient_rock_golem_weakening_aura", "armor_reduction")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_ancient_rock_golem_weakening_aura_bonus_omg:AddCustomTransmitterData()
	return {armor_reduction = self.armor_reduction}
end

--------------------------------------------------------------------------------

function modifier_ancient_rock_golem_weakening_aura_bonus_omg:HandleCustomTransmitterData(data)
	self.armor_reduction = data.armor_reduction
end

--------------------------------------------------------------------------------

function modifier_ancient_rock_golem_weakening_aura_bonus_omg:DeclareFunctions()
    return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

--------------------------------------------------------------------------------

function modifier_ancient_rock_golem_weakening_aura_bonus_omg:GetModifierPhysicalArmorBonus()
    return self.armor_reduction
end