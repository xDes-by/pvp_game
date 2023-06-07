LinkLuaModifier( "modifier_npc_dota_hero_dawnbreaker_permanent_ability", "heroes/hero_dawnbreaker/hero_dawnbreaker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_dawnbreaker_permanent_ability = class({})

function npc_dota_hero_dawnbreaker_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end


function npc_dota_hero_dawnbreaker_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_dawnbreaker_permanent_ability"
end

function npc_dota_hero_dawnbreaker_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_dawnbreaker_permanent_ability:IsRefreshable()
	return false 
end

----------------------------------------------------------------------------

modifier_npc_dota_hero_dawnbreaker_permanent_ability = class({})

function modifier_npc_dota_hero_dawnbreaker_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_dawnbreaker_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_dawnbreaker_permanent_ability:OnCreated( kv )
	self:StartIntervalThink(1)
end

function modifier_npc_dota_hero_dawnbreaker_permanent_ability:OnIntervalThink()
if IsServer() and self:GetAbility() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() and not self:GetCaster():PassivesDisabled() then
	if self:GetAbility():IsCooldownReady() then

		local caster = self:GetCaster()
		local point = caster:GetAbsOrigin()
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local duration = self:GetAbility():GetSpecialValueFor("duration")
		local damage = self:GetCaster():GetAttackDamage()
		
		local damageTable = {
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self, --Optional.
		}

		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),point,	nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)
			if #enemies > 0 then			
			
			for _,enemy in pairs(enemies) do
				Timers:CreateTimer(0.1,function()
					damageTable.victim = enemy
					ApplyDamage( damageTable )
					enemy:AddNewModifier(caster,self,"modifier_stunned",{ duration = duration}	)	
					enemy:EmitSound("Hero_Dawnbreaker.Solar_Guardian.Impact")
				end)
				
				local target = enemy
				local particle_cast = "particles/dawnbreaker/dawnbreaker.vpcf"

				local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
				
				ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
				ParticleManager:SetParticleControlEnt(
					effect_cast,
					1,
					target,
					PATTACH_ABSORIGIN_FOLLOW,
					"attach_hitloc",
					Vector(0,0,0), -- unknown
					true -- unknown, true
				)
				ParticleManager:SetParticleControlEnt(
					effect_cast,
					5,
					target,
					PATTACH_POINT_FOLLOW,
					"attach_hitloc",
					Vector(0,0,0), -- unknown
					true -- unknown, true
				)
				ParticleManager:SetParticleControlEnt(
					effect_cast,
					6,
					self:GetCaster(),
					PATTACH_POINT_FOLLOW,
					"attach_attack1",
					Vector(0,0,0), -- unknown
					true -- unknown, true
				)
				ParticleManager:ReleaseParticleIndex( effect_cast )
			end	
			self:GetAbility():UseResources(false, false, true)
			end
		end
	end
end