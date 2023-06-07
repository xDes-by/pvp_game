LinkLuaModifier( "modifier_npc_dota_hero_shredder_permanent_ability", "heroes/hero_shredder/hero_shredder", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_shredder_permanent_ability = class({})

function npc_dota_hero_shredder_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_shredder_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_shredder_permanent_ability"
end

function npc_dota_hero_shredder_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_shredder_permanent_ability:IsRefreshable()
	return false 
end

---------------------------------------------------------------------------------------

modifier_npc_dota_hero_shredder_permanent_ability = class({})

function modifier_npc_dota_hero_shredder_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_shredder_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_shredder_permanent_ability:DeclareFunctions()		
	local decFuncs = 	{
						MODIFIER_PROPERTY_STATUS_RESISTANCE,
						}		
	return decFuncs			
end

function modifier_npc_dota_hero_shredder_permanent_ability:OnCreated( kv )
	self:StartIntervalThink(1)
end

function modifier_npc_dota_hero_shredder_permanent_ability:OnIntervalThink()
if not IsServer() then return end
	local abil = self:GetParent():FindModifierByName("modifier_shredder_reactive_armor")
	if abil ~= nil then
		self:SetStackCount(abil:GetStackCount())
	end
end

function modifier_npc_dota_hero_shredder_permanent_ability:GetModifierStatusResistance()
	if not self:GetParent():PassivesDisabled() then	
		return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("resist")
	end
end
