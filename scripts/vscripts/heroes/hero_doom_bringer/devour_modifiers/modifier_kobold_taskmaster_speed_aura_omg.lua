modifier_kobold_taskmaster_speed_aura_omg = modifier_kobold_taskmaster_speed_aura_omg or class({})

--------------------------------------------------------------------------------

function modifier_kobold_taskmaster_speed_aura_omg:IsHidden()               return true end
function modifier_kobold_taskmaster_speed_aura_omg:IsPurgable() 		    return false end
function modifier_kobold_taskmaster_speed_aura_omg:RemoveOnDeath()	        return false end
function modifier_kobold_taskmaster_speed_aura_omg:IsAura()	                return not self:GetParent():PassivesDisabled() end
function modifier_kobold_taskmaster_speed_aura_omg:GetAuraRadius()	        return self.radius end
function modifier_kobold_taskmaster_speed_aura_omg:GetAuraSearchTeam()      return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_kobold_taskmaster_speed_aura_omg:GetAuraSearchType()      return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_kobold_taskmaster_speed_aura_omg:GetAuraSearchFlags()     return 0 end
function modifier_kobold_taskmaster_speed_aura_omg:GetModifierAura()        return "modifier_kobold_taskmaster_speed_aura_bonus_omg" end
function modifier_kobold_taskmaster_speed_aura_omg:GetTexture()             return "kobold_taskmaster_speed_aura" end

--------------------------------------------------------------------------------

function modifier_kobold_taskmaster_speed_aura_omg:OnCreated(kv)
    if not IsServer() then return end
    self.radius = GetAbilitySpecial("kobold_taskmaster_speed_aura", "radius")
end

--------------------------------------------------------------------------------

modifier_kobold_taskmaster_speed_aura_bonus_omg = class({})

--------------------------------------------------------------------------------

function modifier_kobold_taskmaster_speed_aura_bonus_omg:IsPurgable()       return false end
function modifier_kobold_taskmaster_speed_aura_bonus_omg:GetTexture()       return "kobold_taskmaster_speed_aura" end

--------------------------------------------------------------------------------

function modifier_kobold_taskmaster_speed_aura_bonus_omg:OnCreated(kv)
    if not IsServer() then return end
    self.bonus_movement_speed = GetAbilitySpecial("kobold_taskmaster_speed_aura", "bonus_movement_speed")
    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_kobold_taskmaster_speed_aura_bonus_omg:AddCustomTransmitterData()
	return {bonus_movement_speed = self.bonus_movement_speed}
end

--------------------------------------------------------------------------------

function modifier_kobold_taskmaster_speed_aura_bonus_omg:HandleCustomTransmitterData(data)
	self.bonus_movement_speed = data.bonus_movement_speed
end

--------------------------------------------------------------------------------

function modifier_kobold_taskmaster_speed_aura_bonus_omg:DeclareFunctions()
    return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

--------------------------------------------------------------------------------

function modifier_kobold_taskmaster_speed_aura_bonus_omg:GetModifierMoveSpeedBonus_Percentage()
    return self.bonus_movement_speed
end