LinkLuaModifier( "modifier_npc_dota_hero_dragon_knight_permanent_ability", "heroes/hero_dragon_knight/hero_dragon_knight", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_dragon_knight_permanent_ability = class({})

function npc_dota_hero_dragon_knight_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_dragon_knight_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_dragon_knight_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_dragon_knight_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_dragon_knight_permanent_ability"
end

---------------------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_dragon_knight_permanent_ability = class({})

function modifier_npc_dota_hero_dragon_knight_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_dragon_knight_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_dragon_knight_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_dragon_knight_permanent_ability:RemoveOnDeath()
	return false
end


function modifier_npc_dota_hero_dragon_knight_permanent_ability:OnCreated( kv )
	self.resist = self:GetAbility():GetSpecialValueFor( "resist" )
end

function modifier_npc_dota_hero_dragon_knight_permanent_ability:OnRefresh( kv )
	self.resist = self:GetAbility():GetSpecialValueFor( "resist" )
end

function modifier_npc_dota_hero_dragon_knight_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE 
	}
	return funcs
end

function modifier_npc_dota_hero_dragon_knight_permanent_ability:GetModifierStatusResistance()
if not self:GetParent():PassivesDisabled() then
	return self.resist
	end
	return 0
end