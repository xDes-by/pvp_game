npc_dota_hero_death_prophet_permanent_ability = class({})

LinkLuaModifier( "modifier_npc_dota_hero_death_prophet_permanent_ability","heroes/hero_death_prophet/hero_death_prophet" , LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_death_prophet_permanent_ability_salo","heroes/hero_death_prophet/hero_death_prophet" , LUA_MODIFIER_MOTION_NONE )

function npc_dota_hero_death_prophet_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_death_prophet_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_death_prophet_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_death_prophet_permanent_ability:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_death_prophet_permanent_ability"
end

modifier_npc_dota_hero_death_prophet_permanent_ability = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) 
        return {
            MODIFIER_EVENT_ON_TAKEDAMAGE
        } 
    end,
})

function modifier_npc_dota_hero_death_prophet_permanent_ability:OnTakeDamage(keys)
    if keys.inflictor and keys.inflictor:GetName() == "death_prophet_carrion_swarm" and self:GetParent():GetName() == "npc_dota_hero_death_prophet" and not self:GetParent():PassivesDisabled() then
        keys.unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_npc_dota_hero_death_prophet_permanent_ability_salo", {duration = self:GetAbility():GetSpecialValueFor("dur") * (1 - keys.unit:GetStatusResistance()) })
    end
end

modifier_npc_dota_hero_death_prophet_permanent_ability_salo = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_npc_dota_hero_death_prophet_permanent_ability_salo:IsDebuff()
	return true
end

function modifier_npc_dota_hero_death_prophet_permanent_ability_salo:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_npc_dota_hero_death_prophet_permanent_ability_salo:OnCreated( kv )
	if not IsServer() then return end

	-- calculate status resistance
	local resist = 1-self:GetParent():GetStatusResistance()
	local duration = kv.duration*resist
	self:SetDuration( duration, true )
end

function modifier_npc_dota_hero_death_prophet_permanent_ability_salo:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_npc_dota_hero_death_prophet_permanent_ability_salo:OnRemoved()
end

function modifier_npc_dota_hero_death_prophet_permanent_ability_salo:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_npc_dota_hero_death_prophet_permanent_ability_salo:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_npc_dota_hero_death_prophet_permanent_ability_salo:GetEffectName()
	return "particles/generic_gameplay/generic_silenced.vpcf"
end

function modifier_npc_dota_hero_death_prophet_permanent_ability_salo:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
