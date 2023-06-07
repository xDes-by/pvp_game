LinkLuaModifier( "modifier_npc_dota_hero_broodmother_permanent_ability", "heroes/hero_broodmother/hero_broodmother", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_broodmother_permanent_ability = class({})

function npc_dota_hero_broodmother_permanent_ability:OnHeroLevelUp()
    if IsServer() then
        if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
        if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
        if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end    
    end
end

function npc_dota_hero_broodmother_permanent_ability:IsStealable()
    return false
end

function npc_dota_hero_broodmother_permanent_ability:IsRefreshable()
    return false 
end

function npc_dota_hero_broodmother_permanent_ability:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_broodmother_permanent_ability"
end
--------------------------------------------------------------------------------------------

modifier_npc_dota_hero_broodmother_permanent_ability = class({})

function modifier_npc_dota_hero_broodmother_permanent_ability:IsHidden()
    return true
end

function modifier_npc_dota_hero_broodmother_permanent_ability:IsDebuff()
    return false
end

function modifier_npc_dota_hero_broodmother_permanent_ability:IsPurgable()
    return false
end

function modifier_npc_dota_hero_broodmother_permanent_ability:OnCreated()
    if self:GetParent():GetName() ~= "npc_dota_hero_broodmother" then return end
    ListenToGameEvent('npc_spawned', Dynamic_Wrap(modifier_npc_dota_hero_broodmother_permanent_ability, 'OnNPCSpawned'), self)
end

function modifier_npc_dota_hero_broodmother_permanent_ability:OnNPCSpawned(data)
    npc = EntIndexToHScript(data.entindex)
    if not IsServer() then return end
    if npc:GetOwner() == nil then return end
    if npc:GetOwner():GetName() == "npc_dota_hero_broodmother" then 
        npc:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_npc_dota_hero_broodmother_permanent_ability",{})
    end
end

function modifier_npc_dota_hero_broodmother_permanent_ability:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
    }
end

function modifier_npc_dota_hero_broodmother_permanent_ability:CheckState()
    return {
        [MODIFIER_STATE_CANNOT_MISS ] = true,
    }
end

function modifier_npc_dota_hero_broodmother_permanent_ability:GetModifierPreAttack_CriticalStrike()
    if not IsServer() then return end
    if IsServer() and (not self:GetParent():PassivesDisabled()) and RandomInt(1,100) <= self:GetAbility():GetSpecialValueFor("chance") then
        return self:GetAbility():GetSpecialValueFor("crit")
    end
end