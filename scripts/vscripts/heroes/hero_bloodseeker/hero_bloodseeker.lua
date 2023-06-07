LinkLuaModifier( "modifier_npc_dota_hero_bloodseeker_permanent_ability", "heroes/hero_bloodseeker/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_bloodseeker_permanent_ability_effect", "heroes/hero_bloodseeker/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_bloodseeker_permanent_ability = class({})

function npc_dota_hero_bloodseeker_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_bloodseeker_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_bloodseeker_permanent_ability"
end

function npc_dota_hero_bloodseeker_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_bloodseeker_permanent_ability:IsRefreshable()
	return false 
end

---------------------------------------------------------------------------------------

modifier_npc_dota_hero_bloodseeker_permanent_ability = class({})

function modifier_npc_dota_hero_bloodseeker_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_bloodseeker_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_bloodseeker_permanent_ability:DeclareFunctions()		
	local decFuncs = 	{
						MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
						}		
	return decFuncs			
end

function modifier_npc_dota_hero_bloodseeker_permanent_ability:OnAbilityFullyCast(params)
	if params.unit == self:GetParent() then
		if params.ability:GetName() == "bloodseeker_rupture" then
			self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_npc_dota_hero_bloodseeker_permanent_ability_effect", { duration = params.ability:GetSpecialValueFor( "duration" )}	)
		end
	end
end

-------------------------------------------------------------------------------------------

modifier_npc_dota_hero_bloodseeker_permanent_ability_effect = class({})

function modifier_npc_dota_hero_bloodseeker_permanent_ability_effect:IsHidden()
	return true
end

function modifier_npc_dota_hero_bloodseeker_permanent_ability_effect:IsPurgable()
	return false
end

function modifier_npc_dota_hero_bloodseeker_permanent_ability_effect:DeclareFunctions()		
	local decFuncs = 	{
						MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
						MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
						}		
	return decFuncs			
end

function modifier_npc_dota_hero_bloodseeker_permanent_ability_effect:GetModifierPreAttack_BonusDamage()
if not self:GetParent():PassivesDisabled() then
	return self:GetAbility():GetSpecialValueFor( "boost" )
	end
	return 0
end

function modifier_npc_dota_hero_bloodseeker_permanent_ability_effect:GetModifierAttackSpeedBonus_Constant()
if not self:GetParent():PassivesDisabled() then
	return self:GetAbility():GetSpecialValueFor( "boost" )
	end
	return 0
end