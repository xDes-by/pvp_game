LinkLuaModifier( "modifier_npc_dota_hero_viper_permanent_ability", "heroes/hero_viper/hero_viper", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_viper_permanent_ability_effect", "heroes/hero_viper/hero_viper", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_viper_permanent_ability = class({})

function npc_dota_hero_viper_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_viper_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_viper_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_viper_permanent_ability"
end
--------------------------------------------------------------------------------------------

modifier_npc_dota_hero_viper_permanent_ability = class({})

function modifier_npc_dota_hero_viper_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_viper_permanent_ability:DeclareFunctions()		
	local decFuncs = {
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	}		
	return decFuncs			
end

function modifier_npc_dota_hero_viper_permanent_ability:OnAttackLanded( params )
	if IsServer() then
		local duration = self:GetAbility():GetSpecialValueFor("duration")	
		if self:GetCaster():PassivesDisabled() then return end
		if RandomInt(1,100) <= self:GetAbility():GetSpecialValueFor("chance") then
			if (self:GetCaster() == params.attacker) and (params.target.IsCreep or params.target.IsHero) then
				if not params.target:IsBuilding() and not params.target:IsMagicImmune() then
					local mod = params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_npc_dota_hero_viper_permanent_ability_effect", {duration = (duration - FrameTime()) * (1 - params.target:GetStatusResistance())})
				end
			end
		end	
	end
end

----------------------------------------------------------------------------

modifier_npc_dota_hero_viper_permanent_ability_effect = class({})

function modifier_npc_dota_hero_viper_permanent_ability_effect:IsHidden()
	return true 
end

function modifier_npc_dota_hero_viper_permanent_ability_effect:IsPurgable()
	return false 
end

function modifier_npc_dota_hero_viper_permanent_ability_effect:OnCreated()
	if not IsServer() then return end
	self.radius = 200
	self.rot_tick = 0.2
	self.damage_per_tick = self:GetAbility():GetSpecialValueFor("damage")/5
	
	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.pfx, 1, Vector(self.radius, 0, 0))
	self:AddParticle(self.pfx, false, false, -1, false, false)	
	
	self:StartIntervalThink(self.rot_tick)
end

function modifier_npc_dota_hero_viper_permanent_ability_effect:OnIntervalThink()
	self.radius = 200
	self.rot_tick = 0.2
	self.damage_per_tick = self:GetAbility():GetSpecialValueFor("damage")/5

	if self.pfx then
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(self.radius, 0, 0))
	end
	
	ApplyDamage({
		victim 			= self:GetParent(),
		damage 			= self.damage_per_tick,
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	})
		
	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
			ApplyDamage({
				victim 			= enemy,
				damage 			= self.damage_per_tick,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})
	end
end