LinkLuaModifier("modifier_npc_dota_hero_arc_warden_permanent_ability", "heroes/hero_arc_warden/hero_arc_warden", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_npc_dota_hero_arc_warden_permanent_ability_delay", "heroes/hero_arc_warden/hero_arc_warden", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_arc_warden_permanent_ability = class({})

function npc_dota_hero_arc_warden_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_arc_warden_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_arc_warden_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_arc_warden_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_arc_warden_permanent_ability" 
end

----------------------------------------------------------------------

modifier_npc_dota_hero_arc_warden_permanent_ability = class({})

function modifier_npc_dota_hero_arc_warden_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_arc_warden_permanent_ability:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK,
	MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_npc_dota_hero_arc_warden_permanent_ability:OnAttack(keys)
	if keys.attacker == self:GetParent() and self:GetAbility():IsFullyCastable() and not self:GetParent():IsIllusion() and not self:GetParent():PassivesDisabled() and not keys.no_attack_cooldown and keys.target:GetUnitName() ~= "npc_dota_observer_wards" and keys.target:GetUnitName() ~= "npc_dota_sentry_wards" then

		self:GetParent():AddNewModifier(keys.target, self:GetAbility(), "modifier_npc_dota_hero_arc_warden_permanent_ability_delay", {delay = 0.1})
		
		self:GetAbility():UseResources(true, true, true)
	end
end

----------------------------------------------------------------------

modifier_npc_dota_hero_arc_warden_permanent_ability_delay = class({})

function modifier_npc_dota_hero_arc_warden_permanent_ability_delay:IsHidden()		return true end
function modifier_npc_dota_hero_arc_warden_permanent_ability_delay:IsPurgable()	return false end
function modifier_npc_dota_hero_arc_warden_permanent_ability_delay:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_npc_dota_hero_arc_warden_permanent_ability_delay:OnCreated(params)
	if not IsServer() then return end
	
	if params and params.delay then
		self:StartIntervalThink(params.delay)
	end
end

function modifier_npc_dota_hero_arc_warden_permanent_ability_delay:OnIntervalThink()
	if self:GetParent():IsAlive() then
		self.attack_bonus = true
		self:GetParent():PerformAttack(self:GetCaster(), true, true, true, false, true, false, false) 
		self.attack_bonus = false
		
		self:StartIntervalThink(-1)
		self:Destroy()
	end
end