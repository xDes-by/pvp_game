LinkLuaModifier( "modifier_npc_dota_hero_nevermore_permanent_ability", "heroes/hero_nevermore/hero_nevermore", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_nevermore_permanent_ability_effect", "heroes/hero_nevermore/hero_nevermore", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_nevermore_permanent_ability = class({})

function npc_dota_hero_nevermore_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_nevermore_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_nevermore_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_nevermore_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_nevermore_permanent_ability"
end

----------------------------------------------------------------------------
modifier_npc_dota_hero_nevermore_permanent_ability = class({})

function modifier_npc_dota_hero_nevermore_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_nevermore_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_nevermore_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_nevermore_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
	return funcs
end

function modifier_npc_dota_hero_nevermore_permanent_ability:OnAbilityFullyCast(params)
	if IsServer() and self:GetAbility() and params.unit == self:GetParent() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() and not self:GetParent():PassivesDisabled() then
		if RandomInt(1,100) <= self:GetAbility():GetSpecialValueFor("chance") then
			if params.ability:GetName() == "nevermore_shadowraze1" then
			local line_pos = self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 200
			local rotation_rate = 360 / 5	
				for i = 2, 5 do
					line_pos = RotatePosition(self:GetParent():GetAbsOrigin(), QAngle(0, rotation_rate, 0), line_pos)
					self:createraze(self:GetParent():GetAbsOrigin(), line_pos, params.ability)
				end	
			end
			if params.ability:GetName() == "nevermore_shadowraze2" then
			local line_pos = self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 450
			local rotation_rate = 360 / 5	
				for i = 2, 5 do
					line_pos = RotatePosition(self:GetParent():GetAbsOrigin(), QAngle(0, rotation_rate, 0), line_pos)
					self:createraze(self:GetParent():GetAbsOrigin(), line_pos, params.ability)
				end	
			end
			if params.ability:GetName() == "nevermore_shadowraze3" then
			local line_pos = self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 700
			local rotation_rate = 360 / 5	
				for i = 2, 5 do
					line_pos = RotatePosition(self:GetParent():GetAbsOrigin(), QAngle(0, rotation_rate, 0), line_pos)
					self:createraze(self:GetParent():GetAbsOrigin(), line_pos, params.ability)
				end	
			end
		end
	end
end

function modifier_npc_dota_hero_nevermore_permanent_ability:createraze(caster_pos, end_pos, ability)
		self.damage = ability:GetSpecialValueFor("shadowraze_damage") * (1 + self:GetParent():GetSpellAmplification(false))

		local enemies = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(),
			end_pos,
			nil,
			250,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		for _,enemy in pairs(enemies) do
			local damageTable = {
				victim = enemy,
				attacker = self:GetParent(),
				damage = self.damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
			}
			ApplyDamage( damageTable )
			if not enemy:HasModifier("modifier_nevermore_shadowraze_debuff") then
				enemy:AddNewModifier( self:GetCaster(), self, "modifier_nevermore_shadowraze_debuff", { duration = 8 } )
			else
				enemy:SetModifierStackCount("modifier_nevermore_shadowraze_debuff",self:GetParent(), enemy:GetModifierStackCount("modifier_nevermore_shadowraze_debuff",self:GetParent()) + 1 )
			end
		end
	self:PlayEffects( self, end_pos, 250 )	
end


function modifier_npc_dota_hero_nevermore_permanent_ability:PlayEffects( self, position, radius )
	local particle_cast = "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, position )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end