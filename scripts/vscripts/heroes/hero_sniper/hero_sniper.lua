LinkLuaModifier( "modifier_npc_dota_hero_sniper_permanent_ability", "heroes/hero_sniper/hero_sniper", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_sniper_permanent_ability_effect", "heroes/hero_sniper/hero_sniper", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_sniper_permanent_ability = class({})

function npc_dota_hero_sniper_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_sniper_permanent_ability:IsStealable()
	return false
end

function npc_dota_hero_sniper_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_sniper_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_sniper_permanent_ability"
end
--------------------------------------------------------------------------------------------

modifier_npc_dota_hero_sniper_permanent_ability = class({})

function modifier_npc_dota_hero_sniper_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_sniper_permanent_ability:OnCreated()
	self.range = self:GetAbility():GetSpecialValueFor("range")
	self.dmg = self:GetAbility():GetSpecialValueFor("dmg")
end

function modifier_npc_dota_hero_sniper_permanent_ability:OnRefresh()
	self:OnCreated()
end

function modifier_npc_dota_hero_sniper_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_npc_dota_hero_sniper_permanent_ability:OnAttackLanded( keys )
if IsServer() then
	self.damage = self:GetParent():GetBaseDamageMin() * (self.dmg/100)
	if self:GetParent() == keys.attacker and not self:GetParent():PassivesDisabled() and not self:GetParent():IsIllusion() then 
		local enemies = FindUnitsInRadius(DOTA_UNIT_TARGET_TEAM_ENEMY, keys.target:GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			for i=1, #enemies do
				if  enemies[i] ~= keys.target then
					ApplyDamage({victim = enemies[i], attacker = keys.attacker, damage = self.damage, damage_type = DAMAGE_TYPE_PHYSICAL,damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
				end
			end	
		self:PlayEffects( keys.target, self.range )			
		end
	end
end

function modifier_npc_dota_hero_sniper_permanent_ability:PlayEffects( target, radius )
	local particle_cast = "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf"
	local sound_cast = "Hero_Jakiro.LiquidFire"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, self:GetCaster() )
end