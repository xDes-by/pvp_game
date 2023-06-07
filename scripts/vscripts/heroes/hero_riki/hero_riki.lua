LinkLuaModifier( "modifier_npc_dota_hero_riki_permanent_ability", "heroes/hero_riki/hero_riki", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_riki_permanent_ability = class({})

function npc_dota_hero_riki_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_riki_permanent_ability:IsStealable()
	return false
end

function npc_dota_hero_riki_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_riki_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_riki_permanent_ability"
end
--------------------------------------------------------------------------------------------

modifier_npc_dota_hero_riki_permanent_ability = class({})

function modifier_npc_dota_hero_riki_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_riki_permanent_ability:OnCreated()
end

function modifier_npc_dota_hero_riki_permanent_ability:OnRefresh()
	self:OnCreated()
end


function modifier_npc_dota_hero_riki_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_npc_dota_hero_riki_permanent_ability:OnAttackLanded( keys )
	if IsServer() then
		if self:GetParent():PassivesDisabled() then return end
		if self:GetParent() ~= keys.attacker then return end
		if self:GetParent():IsIllusion() then return end
			if RandomInt(1,100) <= self:GetAbility():GetSpecialValueFor("chance") then	
				local victim_angle = keys.target:GetAnglesAsVector()
				local victim_forward_vector = keys.target:GetForwardVector()
				
				local victim_angle_rad = victim_angle.y*math.pi/180
				local victim_position = keys.target:GetAbsOrigin()
				local attacker_new = Vector(victim_position.x - 100 * math.cos(victim_angle_rad), victim_position.y - 100 * math.sin(victim_angle_rad), 0)
				
				self:GetParent():SetAbsOrigin(attacker_new)
				FindClearSpaceForUnit(self:GetParent(), attacker_new, true)
				self:GetParent():SetForwardVector(victim_forward_vector)
		end	
	end
end