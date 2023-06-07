LinkLuaModifier( "modifier_npc_dota_hero_puck_permanent_ability", "heroes/hero_puck/hero_puck", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_puck_permanent_ability_effect", "heroes/hero_puck/hero_puck", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_puck_permanent_ability = class({})

function npc_dota_hero_puck_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_puck_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_puck_permanent_ability"
end

function npc_dota_hero_puck_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_puck_permanent_ability:IsRefreshable()
	return false 
end

---------------------------------------------------------------------------------------

modifier_npc_dota_hero_puck_permanent_ability = class({})

function modifier_npc_dota_hero_puck_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_puck_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_puck_permanent_ability:DeclareFunctions()		
	local decFuncs = 	{
						MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
						}		
	return decFuncs			
end

function modifier_npc_dota_hero_puck_permanent_ability:OnAbilityFullyCast(params)
if IsServer() and self:GetAbility() and params.unit == self:GetParent() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() and not self:GetParent():PassivesDisabled() then
	if params.ability:GetName() == "puck_phase_shift" then
		EmitSoundOn( "Hero_MonkeyKing.FurArmy.End", self:GetCaster() )
			self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_npc_dota_hero_puck_permanent_ability_effect", {} )
		end
	end
end

---------------------------------------------------------------------------

modifier_npc_dota_hero_puck_permanent_ability_effect = class({})

function modifier_npc_dota_hero_puck_permanent_ability_effect:IsHidden()
	return true
end

function modifier_npc_dota_hero_puck_permanent_ability_effect:IsPurgable()
	return false
end

function modifier_npc_dota_hero_puck_permanent_ability_effect:DeclareFunctions()		
	local decFuncs = 	{
						MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
						MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE 
						}		
	return decFuncs			
end

function modifier_npc_dota_hero_puck_permanent_ability_effect:OnCreated( kv )
	self:StartIntervalThink(0.1)
end

function modifier_npc_dota_hero_puck_permanent_ability_effect:OnIntervalThink()
if not IsServer() then return end
	self.mod = self:GetParent():FindModifierByName("modifier_puck_phase_shift")
	if self.mod == nil then
		self:Destroy()
	end
end

function modifier_npc_dota_hero_puck_permanent_ability_effect:GetModifierTotalPercentageManaRegen()
	return self:GetAbility():GetSpecialValueFor("ampl")
end

function modifier_npc_dota_hero_puck_permanent_ability_effect:GetModifierHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("ampl")
end