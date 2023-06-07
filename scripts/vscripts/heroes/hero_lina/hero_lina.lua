LinkLuaModifier( "modifier_npc_dota_hero_lina_permanent_ability", "heroes/hero_lina/hero_lina", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_lina_permanent_ability_effect", "heroes/hero_lina/hero_lina", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_lina_permanent_ability = class({})

function npc_dota_hero_lina_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_lina_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_lina_permanent_ability"
end

function npc_dota_hero_lina_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_lina_permanent_ability:IsRefreshable()
	return false 
end

----------------------------------------------------------------------------

modifier_npc_dota_hero_lina_permanent_ability = class({})

function modifier_npc_dota_hero_lina_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_lina_permanent_ability:IsPurgable()
	return false
end


function modifier_npc_dota_hero_lina_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
	return funcs
end

function modifier_npc_dota_hero_lina_permanent_ability:OnAbilityFullyCast(params)
if IsServer() and self:GetAbility() and params.unit == self:GetParent() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() and not self:GetParent():PassivesDisabled() then
	if params.ability:IsItem() then return end
		if params.ability:GetAbilityName() == "lina_dragon_slave" then
			damage = params.ability:GetAbilityDamage()
		
		elseif params.ability:GetAbilityName() == "lina_light_strike_array" then
			damage = params.ability:GetSpecialValueFor("light_strike_array_damage")
		
		elseif params.ability:GetAbilityName() == "lina_laguna_blade" then
			damage = params.ability:GetSpecialValueFor("damage")
		end
		local damageTable = {
			attacker = self:GetCaster(),
			damage = damage * self:GetAbility():GetSpecialValueFor("damage") / 100,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self, --Optional.
		}
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetCaster():GetOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)
			for _,enemy in pairs(enemies) do
				damageTable.victim = enemy
				ApplyDamage( damageTable )
			end	

		self:PlayEffects( self:GetCaster():GetOrigin() )
	end
end

function modifier_npc_dota_hero_lina_permanent_ability:PlayEffects( origin )
	local particle_cast_a = "particles/lina/lina_flame.vpcf"

	local effect_cast_a = ParticleManager:CreateParticle( particle_cast_a, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_a, 0, origin )
	ParticleManager:ReleaseParticleIndex( effect_cast_a )
end