npc_dota_hero_bane_permanent_ability = class({})

LinkLuaModifier( "modifier_npc_dota_hero_bane_permanent_ability_sleep", "heroes/hero_bane/hero_bane", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_bane_permanent_ability_auto_cast", "heroes/hero_bane/hero_bane", LUA_MODIFIER_MOTION_NONE )

function npc_dota_hero_bane_permanent_ability:GetIntrinsicModifierName() 
    return "modifier_npc_dota_hero_bane_permanent_ability_auto_cast" 
end

function npc_dota_hero_bane_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

modifier_npc_dota_hero_bane_permanent_ability_auto_cast = class({})

function modifier_npc_dota_hero_bane_permanent_ability_auto_cast:IsHidden()
    return true
end

function modifier_npc_dota_hero_bane_permanent_ability_auto_cast:IsPurgable()
    return false
end

function modifier_npc_dota_hero_bane_permanent_ability_auto_cast:RemoveOnDeath()    
    return false 
end

function modifier_npc_dota_hero_bane_permanent_ability_auto_cast:OnCreated()
    self:StartIntervalThink(1)
end

function modifier_npc_dota_hero_bane_permanent_ability_auto_cast:OnIntervalThink()
	if IsServer() and self:GetAbility() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() and not self:GetCaster():PassivesDisabled()  then
	if self:GetAbility():IsCooldownReady() then
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetCaster():GetOrigin(),nil,500,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,FIND_CLOSEST,false)
		local target = enemies[RandomInt(1,#enemies)]
		if target == nil then return end
	--	target:PerformAttack(self:GetCaster(), false, true, true, false, false, false, true) 
		local duration = self:GetAbility():GetSpecialValueFor("duration") * (1 - target:GetStatusResistance())
		target:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_npc_dota_hero_bane_permanent_ability_sleep",{ duration = duration })
		self:GetAbility():UseResources(false, false, true)
		end
	end
end

modifier_npc_dota_hero_bane_permanent_ability_sleep = class({})

function modifier_npc_dota_hero_bane_permanent_ability_sleep:IsHidden()
	return false
end

function modifier_npc_dota_hero_bane_permanent_ability_sleep:IsDebuff()
	return true
end

function modifier_npc_dota_hero_bane_permanent_ability_sleep:IsStunDebuff()
	return false
end

function modifier_npc_dota_hero_bane_permanent_ability_sleep:IsPurgable()
	return true
end

function modifier_npc_dota_hero_bane_permanent_ability_sleep:CanParentBeAutoAttacked()
	return false
end

function modifier_npc_dota_hero_bane_permanent_ability_sleep:OnCreated( kv )
	if not IsServer() then return end
	self:GetCaster():PerformAttack(self:GetParent(),true,true,true,true,false,false,true)

	self.anim_rate = self:GetAbility():GetSpecialValueFor( "animation_rate" )
	local sound_cast = "Hero_Bane.Nightmare"
	local sound_loop = "Hero_Bane.Nightmare.Loop"
	EmitSoundOn( sound_cast, self:GetParent() )
	EmitSoundOn( sound_loop, self:GetParent() )
end

function modifier_npc_dota_hero_bane_permanent_ability_sleep:OnDestroy()
	if not IsServer() then return end
	local sound_loop = "Hero_Bane.Nightmare.Loop"
	StopSoundOn( sound_loop, self:GetParent() )
	local sound_stop = "Hero_Bane.Nightmare.End"
	EmitSoundOn( sound_stop, self:GetParent() )
end

function modifier_npc_dota_hero_bane_permanent_ability_sleep:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}
end

function modifier_npc_dota_hero_bane_permanent_ability_sleep:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_npc_dota_hero_bane_permanent_ability_sleep:GetOverrideAnimationRate()
	return self.anim_rate
end

function modifier_npc_dota_hero_bane_permanent_ability_sleep:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end

function modifier_npc_dota_hero_bane_permanent_ability_sleep:GetEffectName()
	return "particles/units/heroes/hero_bane/bane_nightmare.vpcf"
end

function modifier_npc_dota_hero_bane_permanent_ability_sleep:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end