npc_dota_hero_zuus_permanent_ability = class({})

LinkLuaModifier('modifier_npc_dota_hero_zuus_permanent_ability', "heroes/hero_zuus/hero_zuus", LUA_MODIFIER_MOTION_NONE)

function npc_dota_hero_zuus_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_zuus_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_zuus_permanent_ability"
end

----------------------------------------------------------------------------------------

modifier_npc_dota_hero_zuus_permanent_ability = class({})

function modifier_npc_dota_hero_zuus_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_zuus_permanent_ability:RemoveOnDeath()
	return true
end

function modifier_npc_dota_hero_zuus_permanent_ability:OnCreated( kv )
	self:StartIntervalThink(1)
end

function modifier_npc_dota_hero_zuus_permanent_ability:OnIntervalThink()
if IsServer() and self:GetAbility() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() and not self:GetParent():PassivesDisabled() then
	if self:GetAbility():IsCooldownReady() then

		local damageType = DAMAGE_TYPE_MAGICAL
		local int = self:GetCaster():GetIntellect()
		local damage_per_int = self:GetAbility():GetSpecialValueFor("dmg_per_int")
		local damage = damage_per_int * int
		
		local hEnemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
			if hEnemies ~= nil then
				for _,unit in pairs(hEnemies) do
					
					local damage = {
						victim = unit,
						attacker = self:GetCaster(),
						damage = damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						damage_flags = DOTA_DAMAGE_FLAG_NONE,
						ability = self:GetAbility()
					}
					
					ApplyDamage( damage )
					
					local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
					ParticleManager:SetParticleControl(lightningBolt, 0, Vector(self:GetCaster():GetAbsOrigin().x, self:GetCaster():GetAbsOrigin().y , self:GetCaster():GetAbsOrigin().z + self:GetCaster():GetBoundingMaxs().z ))   
					ParticleManager:SetParticleControl(lightningBolt, 1, Vector(unit:GetAbsOrigin().x, unit:GetAbsOrigin().y, unit:GetAbsOrigin().z))
					self:GetCaster():EmitSound("Hero_Zuus.ArcLightning.Cast")
				end	
			end
			self:GetAbility():UseResources(false, false, true)	
		end
	end
end
