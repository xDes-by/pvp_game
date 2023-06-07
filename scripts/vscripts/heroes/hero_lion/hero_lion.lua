npc_dota_hero_lion_permanent_ability = class({})

LinkLuaModifier('modifier_npc_dota_hero_lion_permanent_ability', "heroes/hero_lion/hero_lion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_lion_permanent_ability_effect', "heroes/hero_lion/hero_lion", LUA_MODIFIER_MOTION_NONE)

function npc_dota_hero_lion_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_lion_permanent_ability:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_lion_permanent_ability"
end

modifier_npc_dota_hero_lion_permanent_ability = class({})

function modifier_npc_dota_hero_lion_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_lion_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_lion_permanent_ability:RemoveOnDeath()
	return false
end

function modifier_npc_dota_hero_lion_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_npc_dota_hero_lion_permanent_ability:OnTakeDamage(data)
if RandomInt(1,100) <= self:GetAbility():GetSpecialValueFor("chance") then
	if self:GetAbility():IsCooldownReady() then
		if data.unit == self:GetParent() and self:GetParent():IsRealHero() and self:GetParent():IsAlive() and not data.attacker:IsBuilding() and not data.attacker:IsOther() and data.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not self:GetParent():PassivesDisabled() and data.damage_category == 1 and not data.attacker:IsMagicImmune()then
			self:GetCaster():EmitSound("Hero_Lion.Voodoo")
			data.attacker:AddNewModifier( self:GetParent(), self, "modifier_npc_dota_hero_lion_permanent_ability_effect", { duration = self:GetAbility():GetSpecialValueFor("duration") * (1 - data.attacker:GetStatusResistance())})
			end
		end
	end
end

--------------------------------------------------------------------------------

modifier_npc_dota_hero_lion_permanent_ability_effect = class({})

function modifier_npc_dota_hero_lion_permanent_ability_effect:IsHidden()
	return true
end

function modifier_npc_dota_hero_lion_permanent_ability_effect:IsDebuff()
	return true
end

function modifier_npc_dota_hero_lion_permanent_ability_effect:IsPurgable()
	return false
end

function modifier_npc_dota_hero_lion_permanent_ability_effect:OnCreated( kv )
	self.model = "models/props_gameplay/frog.vmdl"

	if IsServer() then
		self:PlayEffects( true )

		if self:GetParent():IsIllusion() then
			self:GetParent():Kill( self:GetAbility(), self:GetCaster() )
		end
	end
end

function modifier_npc_dota_hero_lion_permanent_ability_effect:OnRefresh( kv )
	if IsServer() then
		self:PlayEffects( true )
	end
end

function modifier_npc_dota_hero_lion_permanent_ability_effect:OnDestroy( kv )
	if IsServer() then
		self:PlayEffects( false )
	end
end


function modifier_npc_dota_hero_lion_permanent_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}
	return funcs
end

function modifier_npc_dota_hero_lion_permanent_ability_effect:GetModifierModelChange()
	return self.model
end

function modifier_npc_dota_hero_lion_permanent_ability_effect:CheckState()
	local state = {
	[MODIFIER_STATE_HEXED] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_MUTED] = true,
	}

	return state
end

function modifier_npc_dota_hero_lion_permanent_ability_effect:PlayEffects( bStart )
	local sound_cast = "Hero_Lion.Hex.Target"
	local particle_cast = "particles/units/heroes/hero_lion/lion_spell_voodoo.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	if bStart then
		EmitSoundOn( sound_cast, self:GetParent() )
	end
end