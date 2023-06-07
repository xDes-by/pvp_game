npc_dota_hero_ogre_magi_permanent_ability = class({})

LinkLuaModifier('modifier_npc_dota_hero_ogre_magi_permanent_ability_helper', "heroes/hero_ogre_magi/hero_ogre_magi", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_ogre_magi_permanent_ability_sleep', "heroes/hero_ogre_magi/hero_ogre_magi", LUA_MODIFIER_MOTION_NONE)

function npc_dota_hero_ogre_magi_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_ogre_magi_permanent_ability:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_ogre_magi_permanent_ability_helper"
end

modifier_npc_dota_hero_ogre_magi_permanent_ability_helper = class({})

function modifier_npc_dota_hero_ogre_magi_permanent_ability_helper:IsHidden()
	return true
end

function modifier_npc_dota_hero_ogre_magi_permanent_ability_helper:IsDebuff()
	return false
end

function modifier_npc_dota_hero_ogre_magi_permanent_ability_helper:IsStunDebuff()
	return false
end

function modifier_npc_dota_hero_ogre_magi_permanent_ability_helper:IsPurgable()
	return false
end

function modifier_npc_dota_hero_ogre_magi_permanent_ability_helper:RemoveOnDeath()
	return true
end

function modifier_npc_dota_hero_ogre_magi_permanent_ability_helper:OnCreated()
	if IsServer() then
		Timers:CreateTimer(1, function()
			self:IncrementStackCount()
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_npc_dota_hero_ogre_magi_permanent_ability_sleep", {duration = 2})
			return RandomInt(15,35)
		end)
	end
end

function modifier_npc_dota_hero_ogre_magi_permanent_ability_helper:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }
end

function modifier_npc_dota_hero_ogre_magi_permanent_ability_helper:GetModifierSpellAmplify_Percentage()
    return self:GetStackCount() * self:GetAbility():GetSpecialValueFor( "bonus_mag_per_sleep" )
end

------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_ogre_magi_permanent_ability_sleep = class({})

function modifier_npc_dota_hero_ogre_magi_permanent_ability_sleep:IsHidden()
	return false
end

function modifier_npc_dota_hero_ogre_magi_permanent_ability_sleep:IsDebuff()
	return false
end

function modifier_npc_dota_hero_ogre_magi_permanent_ability_sleep:IsStunDebuff()
	return false
end

function modifier_npc_dota_hero_ogre_magi_permanent_ability_sleep:IsPurgable()
	return true
end

function modifier_npc_dota_hero_ogre_magi_permanent_ability_sleep:RemoveOnDeath()
	return true
end

function modifier_npc_dota_hero_ogre_magi_permanent_ability_sleep:CheckState()
	local state = {
		[MODIFIER_STATE_NIGHTMARED] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function modifier_npc_dota_hero_ogre_magi_permanent_ability_sleep:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
    }
end

function modifier_npc_dota_hero_ogre_magi_permanent_ability_sleep:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end
function modifier_npc_dota_hero_ogre_magi_permanent_ability_sleep:GetOverrideAnimationRate()
	return 0.2
end

function modifier_npc_dota_hero_ogre_magi_permanent_ability_sleep:GetEffectName()
	return "particles/generic_gameplay/generic_sleep.vpcf"
end

function modifier_npc_dota_hero_ogre_magi_permanent_ability_sleep:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end