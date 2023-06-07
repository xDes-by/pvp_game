LinkLuaModifier( "modifier_npc_dota_hero_faceless_void_permanent_ability", "heroes/hero_faceless_void/hero_faceless_void", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chrono", "heroes/hero_faceless_void/hero_faceless_void", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chrono_debuff", "heroes/hero_faceless_void/hero_faceless_void", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_faceless_void_permanent_ability = class({})

function npc_dota_hero_faceless_void_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_faceless_void_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_faceless_void_permanent_ability"
end

---------------------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_faceless_void_permanent_ability = class({})

function modifier_npc_dota_hero_faceless_void_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_faceless_void_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_faceless_void_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_faceless_void_permanent_ability:RemoveOnDeath()
	return false
end

function modifier_npc_dota_hero_faceless_void_permanent_ability:OnCreated( kv )
end

function modifier_npc_dota_hero_faceless_void_permanent_ability:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_npc_dota_hero_faceless_void_permanent_ability:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_npc_dota_hero_faceless_void_permanent_ability:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and not self:GetParent():IsIllusion() and not self:GetParent():PassivesDisabled() then
	local chance = self:GetAbility():GetSpecialValueFor("chance")
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	local duration = self:GetAbility():GetSpecialValueFor("duration")
	local point = keys.target:GetAbsOrigin()
		if RandomInt(1,100) <= chance then
			CreateModifierThinker(self:GetParent(), self:GetAbility(), "modifier_chrono", {duration = duration}, point, self:GetParent():GetTeamNumber(), false)
			EmitSoundOn("Hero_FacelessVoid.Chronosphere", keys.attacker)
		end
	end
end

---------------------------------------------------------------------------------------------------------------------
modifier_chrono = class({})
function modifier_chrono:IsHidden() return true end
function modifier_chrono:IsDebuff() return false end
function modifier_chrono:IsPurgable() return false end
function modifier_chrono:IsAura() return true end
function modifier_chrono:IsAuraActiveOnDeath() return false end
function modifier_chrono:GetAuraEntityReject(hEntity)
    if IsServer() then
    end
end
function modifier_chrono:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("radius")
end
function modifier_chrono:GetAuraSearchFlags()
    return self:GetAbility():GetAbilityTargetFlags()
end
function modifier_chrono:GetAuraSearchTeam()
    return self:GetAbility():GetAbilityTargetTeam()
end
function modifier_chrono:GetAuraSearchType()
    return self:GetAbility():GetAbilityTargetType()
end
function modifier_chrono:GetModifierAura()
    return "modifier_chrono_debuff"
end
function modifier_chrono:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.radius = self:GetAbility():GetSpecialValueFor("radius")
    
    if IsServer() then
        self.particle_time =    ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_chronosphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                ParticleManager:SetParticleControl(self.particle_time, 0, self.parent:GetAbsOrigin())
                                ParticleManager:SetParticleControl(self.particle_time, 1, Vector(self.radius, self.radius, self.radius))

        self:AddParticle(self.particle_time, false, false, -1, false, false)
    end
end

function modifier_chrono:OnRefresh(table)
	self:OnCreated(table)
end

---------------------------------------------------------------------------------------------------------------------
modifier_chrono_debuff = class({})
function modifier_chrono_debuff:IsHidden() return true end
function modifier_chrono_debuff:IsDebuff() return true end
function modifier_chrono_debuff:IsPurgable() return true end
function modifier_chrono_debuff:IsPurgeException() return true end
function modifier_chrono_debuff:RemoveOnDeath() return true end
function modifier_chrono_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
	return state
end
