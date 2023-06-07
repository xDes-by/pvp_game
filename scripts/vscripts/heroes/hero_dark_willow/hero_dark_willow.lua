LinkLuaModifier('modifier_npc_dota_hero_dark_willow_permanent_ability', "heroes/hero_dark_willow/hero_dark_willow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_dark_willow_bedlam_lua", "heroes/hero_dark_willow/hero_dark_willow", LUA_MODIFIER_MOTION_NONE )



LinkLuaModifier( "modifier_wisp_ambient", "heroes/hero_dark_willow/hero_dark_willow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_wisp_slow", "heroes/hero_dark_willow/hero_dark_willow", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_dark_willow_bedlam_lua_attack", "heroes/hero_dark_willow/hero_dark_willow", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_dark_willow_permanent_ability = class({})

function npc_dota_hero_dark_willow_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_dark_willow_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_dark_willow_permanent_ability"
end

-----------------------------------------------------------------------------------------------

modifier_npc_dota_hero_dark_willow_permanent_ability = class({})

function modifier_npc_dota_hero_dark_willow_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_dark_willow_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_dark_willow_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_dark_willow_permanent_ability:RemoveOnDeath()
	return false
end


function modifier_npc_dota_hero_dark_willow_permanent_ability:OnCreated( kv )
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
end

function modifier_npc_dota_hero_dark_willow_permanent_ability:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_npc_dota_hero_dark_willow_permanent_ability:OnRemoved()
end

function modifier_npc_dota_hero_dark_willow_permanent_ability:OnDestroy()
end

function modifier_npc_dota_hero_dark_willow_permanent_ability:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_npc_dota_hero_dark_willow_permanent_ability:OnTakeDamage(keys)
	if IsServer() and not self:GetParent():PassivesDisabled() then 
		if keys.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self:GetParent() == keys.unit and not keys.attacker:IsOther() and keys.attacker:GetName() ~= "npc_dota_unit_undying_zombie" and not keys.attacker:IsBuilding() then
			if RandomInt(1,100) <= self.chance then
				if self:GetParent():FindAbilityByName("dark_willow_bedlam"):GetLevel() > 0 and self:GetAbility():IsCooldownReady() then
					self:GetAbility():UseResources(false, false, true)
					self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_dark_willow_bedlam_lua", {duration = self:GetAbility():GetSpecialValueFor( "roaming_duration" )})
				end
			end
		end
	end
end

-----------------------------------------------------------------------------------------------

modifier_dark_willow_bedlam_lua = class({})

function modifier_dark_willow_bedlam_lua:IsHidden()
	return true
end

function modifier_dark_willow_bedlam_lua:IsDebuff()
	return false
end

function modifier_dark_willow_bedlam_lua:IsPurgable()
	return false
end

function modifier_dark_willow_bedlam_lua:OnCreated( kv )
	self.parent = self:GetParent()
	self.zero = Vector(0,0,0)
	self.revolution = self:GetAbility():GetSpecialValueFor( "roaming_seconds_per_rotation" )
	self.rotate_radius = self:GetAbility():GetSpecialValueFor( "roaming_radius" )

	if not IsServer() then return end
	self.interval = 0.03
	self.base_facing = Vector(0,1,0)
	self.relative_pos = Vector( -self.rotate_radius, 0, 100 )
	self.rotate_delta = 360/self.revolution * self.interval

	self.position = self.parent:GetOrigin() + self.relative_pos
	self.rotation = 0
	self.facing = self.base_facing

	self.wisp = CreateUnitByName(
		"npc_dark_willow_permanent_ability_wisp",
		self.position,
		true,
		self.parent,
		self.parent:GetOwner(),
		self.parent:GetTeamNumber()
	)
	self.wisp:SetForwardVector( self.facing )
	self.wisp:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_wisp_ambient", -- modifier name
		{} -- kv
	)

	self.wisp:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_dark_willow_bedlam_lua_attack", -- modifier name
		{ duration = kv.duration } -- kv
	)

	self:StartIntervalThink( self.interval )

	self:PlayEffects()
end

function modifier_dark_willow_bedlam_lua:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_dark_willow_bedlam_lua:OnRemoved()
end

function modifier_dark_willow_bedlam_lua:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self.wisp )
end

function modifier_dark_willow_bedlam_lua:OnIntervalThink()
	self.rotation = self.rotation + self.rotate_delta
	local origin = self.parent:GetOrigin()
	self.position = RotatePosition( origin, QAngle( 0, -self.rotation, 0 ), origin + self.relative_pos )
	self.facing = RotatePosition( self.zero, QAngle( 0, -self.rotation, 0 ), self.base_facing )
	self.wisp:SetOrigin( self.position )
	self.wisp:SetForwardVector( self.facing )
end

function modifier_dark_willow_bedlam_lua:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_wisp_aoe_cast.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetParent(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 3, Vector( self.rotate_radius, self.rotate_radius, self.rotate_radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

--------------------------------------------------------------

modifier_wisp_ambient = class({})

function modifier_wisp_ambient:IsHidden()
	return false
end

function modifier_wisp_ambient:IsPurgable()
	return false
end

function modifier_wisp_ambient:OnCreated( kv )
	if not IsServer() then return end
	self:GetParent():SetModel( "models/heroes/dark_willow/dark_willow_wisp.vmdl" )
	self:PlayEffects()
end

function modifier_wisp_ambient:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
	return funcs
end

function modifier_wisp_ambient:GetModifierBaseAttack_BonusDamage()
	if not IsServer() then return end
	local target = self:GetParent():GetOrigin() + self:GetParent():GetForwardVector()
	local forward = self:GetParent():GetForwardVector()
	ParticleManager:SetParticleControl( self.effect_cast, 2, target )
end

function modifier_wisp_ambient:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
	return state
end

function modifier_wisp_ambient:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_willowisp_ambient.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		1,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	self:AddParticle(
		self.effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end

------------------------------------------------------------------------------------------------------------------------

modifier_dark_willow_bedlam_lua_attack = class({})

function modifier_dark_willow_bedlam_lua_attack:IsHidden()
	return false
end

function modifier_dark_willow_bedlam_lua_attack:IsDebuff()
	return false
end

function modifier_dark_willow_bedlam_lua_attack:IsStunDebuff()
	return false
end

function modifier_dark_willow_bedlam_lua_attack:IsPurgable()
	return false
end

function modifier_dark_willow_bedlam_lua_attack:OnCreated( kv )
	local ability = self:GetCaster():FindAbilityByName("dark_willow_bedlam")
	local damage = ability:GetSpecialValueFor( "attack_damage" )
	self.radius = self:GetAbility():GetSpecialValueFor( "attack_radius" )

	if not IsServer() then return end
	local projectile_name = "particles/units/heroes/hero_dark_willow/dark_willow_willowisp_base_attack.vpcf"
	local projectile_speed = 1400

	self.info = {
		Source = self:GetParent(),
		Ability = self:GetAbility(),	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = true,                           -- Optional
		-- bIsAttack = false,                                -- Optional

		ExtraData = {
			damage = damage,
		}
	}

	self:StartIntervalThink( 0.1 )
	self:PlayEffects()
end

function modifier_dark_willow_bedlam_lua_attack:OnIntervalThink()
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		--local effect = self:PlayEffects1( enemy, self.info.iMoveSpeed )
		self.info.Target = enemy
		--self.info.ExtraData.effect = effect
		ProjectileManager:CreateTrackingProjectile( self.info )

		local sound_cast = "Hero_DarkWillow.WillOWisp.Damage"
		EmitSoundOn( sound_cast, self:GetParent() )
		break
	end
	self:StartIntervalThink(-1)
	self:StartIntervalThink( 0.9 )
end

function npc_dota_hero_dark_willow_permanent_ability:OnProjectileHit_ExtraData(target,location, info)
	ApplyDamage({victim = target, attacker = self:GetCaster(), damage = info.damage, damage_type = DAMAGE_TYPE_MAGICAL})
end

function modifier_dark_willow_bedlam_lua_attack:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_wisp_aoe.vpcf"
	local sound_cast = "Hero_DarkWillow.WispStrike.Cast"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )

	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_dark_willow_bedlam_lua_attack:PlayEffects1( target, speed )
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_willowisp_base_attack.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )


	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( speed, 0, 0 ) )

	return effect_cast
end