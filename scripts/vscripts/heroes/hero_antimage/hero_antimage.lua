LinkLuaModifier( "modifier_npc_dota_hero_antimage_permanent_ability", "heroes/hero_antimage/hero_antimage", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_antimage_permanent_ability = class({})

function npc_dota_hero_antimage_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_antimage_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_antimage_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_antimage_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_antimage_permanent_ability"
end

---------------------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_antimage_permanent_ability = class({})

function modifier_npc_dota_hero_antimage_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_antimage_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_antimage_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_antimage_permanent_ability:RemoveOnDeath()
	return false
end


function modifier_npc_dota_hero_antimage_permanent_ability:OnCreated( kv )
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
end

function modifier_npc_dota_hero_antimage_permanent_ability:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_npc_dota_hero_antimage_permanent_ability:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_npc_dota_hero_antimage_permanent_ability:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and not self:GetParent():IsIllusion() and not self:GetParent():PassivesDisabled() then
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
	local radius = self:GetAbility():GetSpecialValueFor("radius")
		if RandomInt(1,100) <= self.chance then
		
		keys.target:SetMana(0)
		local mana_damage = keys.target:GetMaxMana()
			local damageTable = {
				victim = keys.target,
				attacker = self:GetParent(),
				damage = mana_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self, --Optional.
			}
			ApplyDamage(damageTable)

			local enemies = FindUnitsInRadius(
				self:GetCaster():GetTeamNumber(),	-- int, your team number
				keys.target:GetOrigin(),	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
				DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
				0,	-- int, flag filter
				0,	-- int, order filter
				false	-- bool, can grow cache
			)

			for _,enemy in pairs(enemies) do
				damageTable.victim = enemy
				ApplyDamage(damageTable)
			end
			self:PlayEffects2( keys.target, radius )
		end
	end
end

function modifier_npc_dota_hero_antimage_permanent_ability:PlayEffects2( target, radius )
	local particle_target = "particles/units/heroes/hero_antimage/antimage_manavoid.vpcf"
	local sound_target = "Hero_Antimage.ManaVoid"

	local effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_POINT_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_target, 1, Vector( radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_target )

	EmitSoundOn( sound_target, target )
end