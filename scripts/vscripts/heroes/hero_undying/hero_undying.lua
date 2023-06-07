LinkLuaModifier( "modifier_npc_dota_hero_undying_permanent_ability", "heroes/hero_undying/hero_undying", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_undying_permanent_ability = class({})

function npc_dota_hero_undying_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_undying_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_undying_permanent_ability"
end

function npc_dota_hero_undying_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_undying_permanent_ability:IsRefreshable()
	return false 
end

---------------------------------------------------------------------------------------

modifier_npc_dota_hero_undying_permanent_ability = class({})

function modifier_npc_dota_hero_undying_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_undying_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_undying_permanent_ability:OnCreated( kv )
	self:StartIntervalThink(0.2)
end

function GenerateZombieType()
	local zombie_types = {"npc_dota_unit_undying_zombie", "npc_dota_unit_undying_zombie_torso"}

	local chosen_zombie = zombie_types[RandomInt(1, #zombie_types)]    
	return chosen_zombie
end


function modifier_npc_dota_hero_undying_permanent_ability:OnIntervalThink()
if IsServer() and self:GetAbility() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() and not self:GetParent():PassivesDisabled() then
	if self:GetAbility():IsCooldownReady() then
			self.mod = self:GetParent():FindModifierByName("modifier_undying_flesh_golem")
			if self.mod ~= nil then
				print(GenerateZombieType())
				local zombie = CreateUnitByName(GenerateZombieType(), self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
				zombie:EmitSound("Undying_Zombie.Spawn")
				zombie:AddNewModifier( zombie, nil, "modifier_kill", {duration = 10})
				local ownerability = self:GetCaster():FindAbilityByName("undying_tombstone")
					if ownerability ~= nil and ownerability:GetLevel() > 0 then
						local  level = ownerability:GetLevel()
						local deathlust_ability = zombie:FindAbilityByName("undying_tombstone_zombie_deathstrike"):SetLevel(level)
					end
				
				FindClearSpaceForUnit(zombie, self:GetCaster():GetAbsOrigin() + RandomVector(self:GetCaster():GetHullRadius() + zombie:GetHullRadius()), true)
				ResolveNPCPositions(zombie:GetAbsOrigin(), self:GetCaster():GetHullRadius()) 
				self:GetAbility():UseResources(false, false, true)
			end
			
		end
	end	
end