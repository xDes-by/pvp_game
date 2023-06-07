LinkLuaModifier( "modifier_npc_dota_hero_snapfire_permanent_ability", "heroes/hero_snapfire/hero_snapfire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mortimer", "heroes/hero_snapfire/hero_snapfire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mortimer_thinker", "heroes/hero_snapfire/hero_snapfire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slow", "heroes/hero_snapfire/hero_snapfire", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_snapfire_permanent_ability = class({})

function npc_dota_hero_snapfire_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_snapfire_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_snapfire_permanent_ability"
end

function npc_dota_hero_snapfire_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_snapfire_permanent_ability:IsRefreshable()
	return false 
end

----------------------------------------------------------------------------

modifier_npc_dota_hero_snapfire_permanent_ability = class({})

function modifier_npc_dota_hero_snapfire_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_snapfire_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_snapfire_permanent_ability:OnCreated( kv )
	self:StartIntervalThink(1)
end

function modifier_npc_dota_hero_snapfire_permanent_ability:OnIntervalThink()
if IsServer() and self:GetAbility() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() then
	if self:GetAbility():IsCooldownReady() then
		local duration = self:GetAbility():GetSpecialValueFor("duration")
		local damage = self:GetAbility():GetSpecialValueFor("damage")
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local range = 800
		local caster_pos = self:GetCaster():GetAbsOrigin()
		local angle = RandomInt(0, 360)
		local variance = RandomInt(-range, range)
		local dy = math.sin(angle) * variance
		local dx = math.cos(angle) * variance
		local target_pos = Vector(caster_pos.x + dx, caster_pos.y + dy, caster_pos.z)

		self:GetCaster():AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_mortimer", -- modifier name
			{
				duration = 0.5,
				pos_x = target_pos.x,
				pos_y = target_pos.y,
			} -- kv
		)
		
			local level = self:GetAbility():GetLevel()-1
			--self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(level))
			self:GetAbility():UseResources(false, false, true)
		end
	end
end

function npc_dota_hero_snapfire_permanent_ability:OnProjectileHit( target, location )
	if not target then return end

	local damage = self:GetSpecialValueFor("damage")
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), location, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		enemy:AddNewModifier(self:GetCaster(),self,"modifier_slow",{ duration = duration  * (1 - enemy:GetStatusResistance())}	)
	end


	self:PlayEffects( target:GetOrigin() )
end

function npc_dota_hero_snapfire_permanent_ability:PlayEffects( loc )
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_impact.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_linger.vpcf"
	local sound_cast = "Hero_Snapfire.MortimerBlob.Impact"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 3, loc )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, loc )
	ParticleManager:SetParticleControl( effect_cast, 1, loc )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local sound_location = "Hero_Snapfire.MortimerBlob.Impact"
	EmitSoundOnLocationWithCaster( loc, sound_location, self:GetCaster() )
end


------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

modifier_mortimer = class({})

function modifier_mortimer:IsHidden()
	return false
end

function modifier_mortimer:IsDebuff()
	return false
end

function modifier_mortimer:IsStunDebuff()
	return false
end

function modifier_mortimer:IsPurgable()
	return false
end

function modifier_mortimer:OnCreated( kv )
	self.min_range = 100
	self.max_range = self:GetAbility():GetCastRange( Vector(0,0,0), nil )
	self.range = self.max_range-self.min_range
	
	self.min_travel = 0.8
	self.max_travel = 2.0
	self.travel_range = self.max_travel-self.min_travel
	
	self.projectile_speed = 1300
	
	self.turn_rate = 75

	if not IsServer() then return end

	local interval = 10
	self:SetValidTarget( Vector( kv.pos_x, kv.pos_y, 0 ) )
	local projectile_name = "particles/units/heroes/hero_snapfire/snapfire_lizard_blobs_arced.vpcf"
	local projectile_start_radius = 0
	local projectile_end_radius = 0

	self.info = {
		Source = self:GetCaster(),
		Ability = self:GetAbility(),	
		
		EffectName = projectile_name,
		iMoveSpeed = self.projectile_speed,
		bDodgeable = false,                           -- Optional
	
		vSourceLoc = self:GetCaster():GetOrigin(),                -- Optional (HOW)
		
		bDrawsOnMinimap = false,                          -- Optional
		bVisibleToEnemies = true,                         -- Optional
	}
	self:StartIntervalThink( interval )
	self:OnIntervalThink()
end

function modifier_mortimer:OnIntervalThink()
	local thinker = CreateModifierThinker(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_mortimer_thinker", -- modifier name
		{ travel_time = self.travel_time }, -- kv
		self.target,
		self:GetParent():GetTeamNumber(),
		false
	)

	self.info.iMoveSpeed = self.vector:Length2D()/self.travel_time
	self.info.Target = thinker

	ProjectileManager:CreateTrackingProjectile( self.info )

	local sound_cast = "Hero_Snapfire.MortimerBlob.Launch"
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_mortimer:SetValidTarget( location )
	local origin = self:GetParent():GetOrigin()
	local vec = location-origin
	local direction = vec
	direction.z = 0
	direction = direction:Normalized()

	if vec:Length2D()<self.min_range then
		vec = direction * self.min_range
	elseif vec:Length2D()>self.max_range then
		vec = direction * self.max_range
	end

	self.target = GetGroundPosition( origin + vec, nil )
	self.vector = vec
	self.travel_time = (vec:Length2D()-self.min_range)/self.range * self.travel_range + self.min_travel
end

--------------------------------------------------------------------------------------------------------
modifier_mortimer_thinker = class({})

function modifier_mortimer_thinker:OnCreated( kv )
end

---------------------------------------------------------------------------------------------------------

modifier_slow = class({})

function modifier_slow:IsHidden()
	return false
end

function modifier_slow:IsDebuff()
	return false
end

function modifier_slow:IsPurgable()
	return false
end

function modifier_slow:OnCreated( kv )
	self.slow = self:GetAbility():GetSpecialValueFor( "slow" )
end

function modifier_slow:OnRefresh( kv )
	self.slow = self:GetAbility():GetSpecialValueFor( "slow" )
end

function modifier_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_slow:GetModifierMoveSpeedBonus_Constant()
	return self.slow * (-1)
end