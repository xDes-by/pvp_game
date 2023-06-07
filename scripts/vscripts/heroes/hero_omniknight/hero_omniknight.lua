LinkLuaModifier( "modifier_npc_dota_hero_omniknight_permanent_ability", "heroes/hero_omniknight/hero_omniknight", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_omniknight_permanent_ability = class({})

function npc_dota_hero_omniknight_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_omniknight_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_omniknight_permanent_ability"
end

function npc_dota_hero_omniknight_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_omniknight_permanent_ability:IsRefreshable()
	return false 
end

----------------------------------------------------------------------------

modifier_npc_dota_hero_omniknight_permanent_ability = class({})

function modifier_npc_dota_hero_omniknight_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_omniknight_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_omniknight_permanent_ability:OnCreated( kv )
	self:StartIntervalThink(1)
end

function modifier_npc_dota_hero_omniknight_permanent_ability:OnIntervalThink()
if IsServer() and self:GetAbility() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() then
	if self:GetAbility():IsCooldownReady() then
		local heal = self:GetAbility():GetSpecialValueFor("hp")
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		
		self:GetCaster():Heal( heal, self:GetAbility() )
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			self:GetCaster():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		-- Apply Damage	 
		local damageTable = {
			attacker = self:GetCaster(),
			damage = heal,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility(), --Optional.
		}
		for _,enemy in pairs(enemies) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			self:PlayEffects2( self:GetCaster(), enemy )
		end

		self:PlayEffects1( self:GetCaster(), radius )
			
		local level = self:GetAbility():GetLevel()-1
		--self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(level))
		self:GetAbility():UseResources(false, false, true)
		end
	end
end


function modifier_npc_dota_hero_omniknight_permanent_ability:PlayEffects1( target, radius )
	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf"
	local particle_target = "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
	local sound_target = "Hero_Omniknight.Purification"
	
	local effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_target, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_target )
	EmitSoundOn( sound_target, target )

	-- Create Caster Effects
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack2",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_npc_dota_hero_omniknight_permanent_ability:PlayEffects2( origin, target )
	local particle_target = "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf"
	local effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_target,
		0,
		origin,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		origin:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_target,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_target )
end