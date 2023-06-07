LinkLuaModifier( "modifier_npc_dota_hero_invoker_permanent_ability", "heroes/hero_invoker/hero_invoker", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_invoker_permanent_ability = class({})

function npc_dota_hero_invoker_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_invoker_permanent_ability:IsStealable()
	return false
end

function npc_dota_hero_invoker_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_invoker_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_invoker_permanent_ability"
end
--------------------------------------------------------------------------------------------

modifier_npc_dota_hero_invoker_permanent_ability = class({})

function modifier_npc_dota_hero_invoker_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_invoker_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_npc_dota_hero_invoker_permanent_ability:OnTakeDamage( params )
	  if IsServer() then
        if params.attacker ~= self:GetParent() then return end
		
		if self:GetParent():PassivesDisabled() then return end
		
		if self:GetParent():GetTeamNumber() == params.unit:GetTeamNumber() then return end

        if params.damage_type ~= DAMAGE_TYPE_MAGICAL and params.damage_type ~= DAMAGE_TYPE_PURE and params.inflictor == nil then return end

        if params.damage_flags == DOTA_DAMAGE_FLAG_REFLECTION then return end
		
		if RandomInt(1,100) <= self:GetAbility():GetSpecialValueFor("chance") then
			ApplyDamage({
				victim = params.unit,
				attacker = params.attacker,
				damage = params.damage,
				damage_type = params.damage_type,
				ability = self:GetAbility(),
				damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
			})

			SendOverheadEventMessage( params.unit, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE , params.unit, params.damage * 2, nil )
		end
	end
end