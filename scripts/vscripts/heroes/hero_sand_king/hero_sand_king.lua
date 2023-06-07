LinkLuaModifier( "modifier_npc_dota_hero_sand_king_permanent_ability", "heroes/hero_sand_king/hero_sand_king", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_sand_king_permanent_ability = class({})

function npc_dota_hero_sand_king_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_sand_king_permanent_ability"
end

function npc_dota_hero_sand_king_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_sand_king_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_sand_king_permanent_ability:IsRefreshable()
	return false 
end

----------------------------------------------------------------------------

modifier_npc_dota_hero_sand_king_permanent_ability = class({})

function modifier_npc_dota_hero_sand_king_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_sand_king_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_sand_king_permanent_ability:OnCreated( kv )
	self:StartIntervalThink(1)
end

function modifier_npc_dota_hero_sand_king_permanent_ability:OnIntervalThink()
if IsServer() and self:GetAbility() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() and not self:GetParent():PassivesDisabled() then
	if self:GetAbility():IsCooldownReady() then
		
		local caster = self:GetCaster()
		local point = caster:GetAbsOrigin()
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local try_damage = self:GetAbility():GetSpecialValueFor("damage")
		
		local damageTable = {
			attacker = self:GetCaster(),
			damage = try_damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self, --Optional.
		}

		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),point,	nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)
			
				EmitSoundOn( "Ability.SandKing_Epicenter.spell", caster )
				Timers:CreateTimer(0.1, function() 
				StopSoundOn( "Ability.SandKing_Epicenter.spell", caster )
				end)
			
			Timers:CreateTimer(0.01, function() 
				caster.ShieldParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControl(caster.ShieldParticle, 1, Vector(radius,0,radius))
				ParticleManager:SetParticleControlEnt(caster.ShieldParticle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			end)

			for _,enemy in pairs(enemies) do
				damageTable.victim = enemy
				ApplyDamage( damageTable )
			end	
			
			local level = self:GetAbility():GetLevel()-1
			--self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(level))
			self:GetAbility():UseResources(false, false, true)
		end
	end
end