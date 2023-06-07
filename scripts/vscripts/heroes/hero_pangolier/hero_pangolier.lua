LinkLuaModifier( "modifier_npc_dota_hero_pangolier_permanent_ability", "heroes/hero_pangolier/hero_pangolier", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_pangolier_permanent_ability_effect", "heroes/hero_pangolier/hero_pangolier", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_pangolier_permanent_ability = class({})

function npc_dota_hero_pangolier_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_pangolier_permanent_ability:IsStealable()
	return false
end

function npc_dota_hero_pangolier_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_pangolier_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_pangolier_permanent_ability"
end
--------------------------------------------------------------------------------------------

modifier_npc_dota_hero_pangolier_permanent_ability = class({})

function modifier_npc_dota_hero_pangolier_permanent_ability:OnCreated()
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
end

function modifier_npc_dota_hero_pangolier_permanent_ability:OnRefresh()
	self:OnCreated()
end

function modifier_npc_dota_hero_pangolier_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_npc_dota_hero_pangolier_permanent_ability:OnAttackLanded( keys )
	if IsServer() then
		if self:GetParent():PassivesDisabled() then return end
		if self:GetParent() ~= keys.attacker then return end
		if self:GetParent():IsIllusion() then return end
			if RandomInt(1,100) <=  self.chance then	
				if not keys.target:HasModifier("modifier_npc_dota_hero_pangolier_permanent_ability_effect") then
				keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_npc_dota_hero_pangolier_permanent_ability_effect", {duration = self.duration * (1 - keys.target:GetStatusResistance())})
			end
		end	
	end
end

--------------------------------------------------------------------------------------

modifier_npc_dota_hero_pangolier_permanent_ability_effect = class({})

function modifier_npc_dota_hero_pangolier_permanent_ability_effect:IsHidden() return false end
function modifier_npc_dota_hero_pangolier_permanent_ability_effect:IsDebuff() return true end
function modifier_npc_dota_hero_pangolier_permanent_ability_effect:IsPurgable() return true end

function modifier_npc_dota_hero_pangolier_permanent_ability_effect:OnCreated()
	self.arm = self:GetParent():GetPhysicalArmorValue(false) * (-1)
			local icon_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_heartpiercer_debuff.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(icon_particle, false, false, -1, true, true)
end

function modifier_npc_dota_hero_pangolier_permanent_ability_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_npc_dota_hero_pangolier_permanent_ability_effect:GetModifierPhysicalArmorBonus()
	return self.arm
end