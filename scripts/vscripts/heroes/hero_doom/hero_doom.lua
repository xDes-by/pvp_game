LinkLuaModifier("modifier_npc_dota_hero_doom_bringer_permanent_ability", "heroes/hero_doom/hero_doom", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_doom_bringer_permanent_ability = class({})


function npc_dota_hero_doom_bringer_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_doom_bringer_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_doom_bringer_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_doom_bringer_permanent_ability"
end

if modifier_npc_dota_hero_doom_bringer_permanent_ability == nil then 
    modifier_npc_dota_hero_doom_bringer_permanent_ability = class({})
end

function modifier_npc_dota_hero_doom_bringer_permanent_ability:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    }
end

function modifier_npc_dota_hero_doom_bringer_permanent_ability:OnDeath(params)
    local parent = self:GetParent()
	if not self:GetParent():PassivesDisabled() then
		if IsMyKilledBadGuys(parent, params) then
			self:IncrementStackCount()
			parent:CalculateStatBonus(true)
			parent:Heal(self:GetAbility():GetSpecialValueFor( "hp" ), nil)
		end
	end
end

function modifier_npc_dota_hero_doom_bringer_permanent_ability:GetModifierExtraHealthBonus(params)
    return self:GetStackCount() * self:GetAbility():GetSpecialValueFor( "hp" )
end

function modifier_npc_dota_hero_doom_bringer_permanent_ability:IsHidden()
	return false
end

function modifier_npc_dota_hero_doom_bringer_permanent_ability:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_doom_bringer_permanent_ability:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_doom_bringer_permanent_ability:OnCreated(kv)
end

function IsMyKilledBadGuys(hero, params)
    if not params.unit:IsCreep() then
        return false
    end
    local attacker = params.attacker
    if hero == attacker then
        return true
    else
        if hero == attacker:GetOwner() then
            return true
        else
            return false
        end
    end
end