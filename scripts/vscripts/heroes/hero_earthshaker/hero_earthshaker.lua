LinkLuaModifier( "modifier_npc_dota_hero_earthshaker_permanent_ability", "heroes/hero_earthshaker/hero_earthshaker", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_earthshaker_permanent_ability = class({})

function npc_dota_hero_earthshaker_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_earthshaker_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_earthshaker_permanent_ability"
end

function npc_dota_hero_earthshaker_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_earthshaker_permanent_ability:IsRefreshable()
	return false 
end

---------------------------------------------------------------------------------------

modifier_npc_dota_hero_earthshaker_permanent_ability = class({})

function modifier_npc_dota_hero_earthshaker_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_earthshaker_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_earthshaker_permanent_ability:OnCreated( kv )
	self:StartIntervalThink(1)
end

function modifier_npc_dota_hero_earthshaker_permanent_ability:OnIntervalThink()
if IsServer() and self:GetAbility() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() and not self:GetParent():PassivesDisabled() then
	if self:GetAbility():IsCooldownReady() then						
			local aftershock = self:GetCaster():FindAbilityByName("earthshaker_aftershock")
			if aftershock ~= nil then
				if aftershock:GetLevel() > 0 then 
					local range = aftershock:GetSpecialValueFor( "aftershock_range" )
					local damage = aftershock:GetSpecialValueFor( "aftershock_damage" )
					local duration = aftershock:GetDuration()
					local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
						for _,enemy in pairs(enemies) do
							if not enemy:IsMagicImmune() then
							enemy:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_stunned", { duration = duration  * (1 - enemy:GetStatusResistance())}	)
								self.damageTable = {
									victim = enemy,
									attacker = self:GetCaster(),
									damage = damage,
									damage_type = DAMAGE_TYPE_MAGICAL,
								}
								ApplyDamage(self.damageTable)
							end
						end
					self:PlayEffects()
					self:GetAbility():UseResources(false, false, true)
				end
			end
		end
	end
end


function modifier_npc_dota_hero_earthshaker_permanent_ability:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_earthshaker/earthshaker_aftershock.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 300, 300, 300) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end