npc_dota_hero_naga_siren_permanent_ability = class({})

LinkLuaModifier('modifier_npc_dota_hero_naga_siren_permanent_ability', "heroes/hero_naga_siren/hero_naga_siren", LUA_MODIFIER_MOTION_NONE)

function npc_dota_hero_naga_siren_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_naga_siren_permanent_ability:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_naga_siren_permanent_ability"
end

modifier_npc_dota_hero_naga_siren_permanent_ability = class({})

function modifier_npc_dota_hero_naga_siren_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_naga_siren_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_naga_siren_permanent_ability:OnCreated( kv )
end

function modifier_npc_dota_hero_naga_siren_permanent_ability:OnRefresh( kv )
end

function modifier_npc_dota_hero_naga_siren_permanent_ability:DeclareFunctions()
	local funcs = {
		 MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_npc_dota_hero_naga_siren_permanent_ability:OnTakeDamage( params )
if IsServer() then
	if self:GetAbility() and params.attacker == self:GetParent() and not self:GetParent():PassivesDisabled() then
		if not params.inflictor  then return end
        if params.inflictor:GetName() ~= "naga_siren_rip_tide"  then return end
			if params.unit:HasModifier("modifier_naga_siren_ensnare") then
				ApplyDamage({victim = params.unit, attacker = self:GetParent(), damage = params.damage * self:GetAbility():GetSpecialValueFor("dopdmg") * 0.01, damage_type = DAMAGE_TYPE_PURE,damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
			end
		end
	end
end


   
