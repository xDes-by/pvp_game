LinkLuaModifier( "modifier_npc_dota_hero_rubick_permanent_ability", "heroes/hero_rubic/hero_rubic", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_rubick_permanent_ability = class({})

function npc_dota_hero_rubick_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_rubick_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_rubick_permanent_ability"
end

function npc_dota_hero_rubick_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_rubick_permanent_ability:IsRefreshable()
	return false 
end

---------------------------------------------------------------------------------------

modifier_npc_dota_hero_rubick_permanent_ability = class({})

function modifier_npc_dota_hero_rubick_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_rubick_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_rubick_permanent_ability:DeclareFunctions()		
	local decFuncs = 	{
						MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
						}		
	return decFuncs			
end

function modifier_npc_dota_hero_rubick_permanent_ability:GetModifierPercentageCasttime()
if not IsServer() then return end
	return self:GetAbility():GetSpecialValueFor("resist") * (-1)
end

