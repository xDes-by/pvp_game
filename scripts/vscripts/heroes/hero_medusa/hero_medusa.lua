LinkLuaModifier( "modifier_npc_dota_hero_medusa_permanent_ability", "heroes/hero_medusa/hero_medusa", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_medusa_permanent_ability = class({})

function npc_dota_hero_medusa_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_medusa_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_medusa_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_medusa_permanent_ability"
end
--------------------------------------------------------------------------------------------

modifier_npc_dota_hero_medusa_permanent_ability = class({})

function modifier_npc_dota_hero_medusa_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_medusa_permanent_ability:OnCreated()
	self.mana = self:GetAbility():GetSpecialValueFor("mana")
end

function modifier_npc_dota_hero_medusa_permanent_ability:OnRefresh()
	self:OnCreated()
end

function modifier_npc_dota_hero_medusa_permanent_ability:DeclareFunctions()		
	local decFuncs = 	{
						MODIFIER_PROPERTY_MANA_BONUS,
						}		
	return decFuncs			
end

function modifier_npc_dota_hero_medusa_permanent_ability:GetModifierManaBonus()
	return self.mana
end