LinkLuaModifier( "modifier_npc_dota_hero_mirana_permanent_ability", "heroes/hero_mirana/hero_mirana", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_mirana_permanent_ability = class({})

function npc_dota_hero_mirana_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_mirana_permanent_ability"
end

function npc_dota_hero_mirana_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_mirana_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_mirana_permanent_ability:IsRefreshable()
	return false 
end

----------------------------------------------------------------------------

modifier_npc_dota_hero_mirana_permanent_ability = class({})

function modifier_npc_dota_hero_mirana_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_mirana_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_mirana_permanent_ability:OnCreated( kv )
	self:StartIntervalThink(1)
end

function modifier_npc_dota_hero_mirana_permanent_ability:OnIntervalThink()
if IsServer() and self:GetAbility() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() and not self:GetParent():PassivesDisabled() then
	if self:GetAbility():IsCooldownReady() then
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local damage = self:GetAbility():GetSpecialValueFor("damage")
		local count = 3
		
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetCaster():GetAbsOrigin(),nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if count > 0 then
					count = count - 1
						if not enemy:IsMagicImmune() then
							local particle_starfall_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
							ParticleManager:SetParticleControl(particle_starfall_fx, 0, enemy:GetAbsOrigin())
							ParticleManager:SetParticleControl(particle_starfall_fx, 1, enemy:GetAbsOrigin())
							ParticleManager:SetParticleControl(particle_starfall_fx, 3, enemy:GetAbsOrigin())
							ParticleManager:ReleaseParticleIndex(particle_starfall_fx)
							
							Timers:CreateTimer(0.57, function()
								if not enemy:IsMagicImmune() then
									EmitSoundOn("Ability.StarfallImpact", enemy)

									local damageTable = {
										victim = enemy,
										damage = damage,
										damage_type = DAMAGE_TYPE_MAGICAL,
										attacker = self:GetCaster(),
									}
									ApplyDamage(damageTable)
									self:GetAbility():UseResources(false, false, true)
								end
							end)
						end
					end
				end
			end	
		end
	end
end