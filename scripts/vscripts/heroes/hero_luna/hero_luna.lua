LinkLuaModifier('modifier_npc_dota_hero_luna_permanent_ability', "heroes/hero_luna/hero_luna", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_luna_permanent_ability = class({})

function npc_dota_hero_luna_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_luna_permanent_ability'
end

function npc_dota_hero_luna_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

modifier_npc_dota_hero_luna_permanent_ability = class({})

function modifier_npc_dota_hero_luna_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_luna_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_luna_permanent_ability:RemoveOnDeath()
	return false
end

function modifier_npc_dota_hero_luna_permanent_ability:OnCreated( kv )
	self.proc = 0
end

function modifier_npc_dota_hero_luna_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_npc_dota_hero_luna_permanent_ability:GetModifierProcAttack_Feedback( params )
	if not IsServer() then return end
	if self:GetParent():PassivesDisabled() then return end
	self.proc = self.proc + 1
	if self.proc >= self:GetAbility():GetSpecialValueFor("count") then
	self.proc = 0
		
		local line_pos = self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 1000
		local projectile_direction = line_pos-self:GetParent():GetOrigin()
		projectile_direction.z = 0
		projectile_direction = projectile_direction:Normalized()

	
		local info = {
		Source = self:GetParent(),
		Ability = self:GetAbility(),
		vSpawnOrigin = self:GetParent():GetAbsOrigin(),
		
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = "particles/luna/luna.vpcf",
	    fDistance = 1000,
	    fStartRadius = 200,
	    fEndRadius = 200,
		vVelocity = projectile_direction * 500,
	
		bProvidesVision = true,
		iVisionRadius = 300,
		iVisionTeamNumber = self:GetParent():GetTeamNumber(),
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)
	
	end
end

function npc_dota_hero_luna_permanent_ability:OnProjectileHitHandle( target, location, handle )
	if not target then
		local vision_radius = 300
		local vision_duration = 2
		AddFOWViewer( self:GetCaster():GetTeamNumber(), location, vision_radius, vision_duration, false )
		return
	end
	self:GetCaster():PerformAttack( target, true, false, true, true, false, false, true)
end
