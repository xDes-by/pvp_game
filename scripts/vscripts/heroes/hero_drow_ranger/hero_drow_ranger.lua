LinkLuaModifier('modifier_npc_dota_hero_drow_ranger_permanent_ability', "heroes/hero_drow_ranger/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_drow_ranger_permanent_ability = class({})

function npc_dota_hero_drow_ranger_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_drow_ranger_permanent_ability'
end

function npc_dota_hero_drow_ranger_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

modifier_npc_dota_hero_drow_ranger_permanent_ability = class({})

function modifier_npc_dota_hero_drow_ranger_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_drow_ranger_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_drow_ranger_permanent_ability:RemoveOnDeath()
	return false
end

function modifier_npc_dota_hero_drow_ranger_permanent_ability:OnCreated( kv )
end

function modifier_npc_dota_hero_drow_ranger_permanent_ability:OnRefresh( kv )
end

function modifier_npc_dota_hero_drow_ranger_permanent_ability:DeclareFunctions()
	local funcs	=	{
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_npc_dota_hero_drow_ranger_permanent_ability:GetModifierIncomingDamage_Percentage()
	if RandomInt(1,100) <= self:GetAbility():GetSpecialValueFor( "persent" ) then
		local backtrack_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(backtrack_fx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(backtrack_fx)
		return -100
	end
end