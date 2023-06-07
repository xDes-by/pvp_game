LinkLuaModifier( "modifier_npc_dota_hero_centaur_permanent_ability", "heroes/hero_centaur/hero_centaur", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_centaur_permanent_ability = class({})

function npc_dota_hero_centaur_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_centaur_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_centaur_permanent_ability"
end

function npc_dota_hero_centaur_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_centaur_permanent_ability:IsRefreshable()
	return false 
end

---------------------------------------------------------------------------------------

modifier_npc_dota_hero_centaur_permanent_ability = class({})

function modifier_npc_dota_hero_centaur_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_centaur_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_centaur_permanent_ability:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_npc_dota_hero_centaur_permanent_ability:CheckState()
  local state = {
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  }
  return state
end

function modifier_npc_dota_hero_centaur_permanent_ability:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_npc_dota_hero_centaur_permanent_ability:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor( "speed" )
end