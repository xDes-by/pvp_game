LinkLuaModifier( "modifier_npc_dota_hero_obsidian_destroyer_permanent_ability","heroes/hero_obsidian_destroyer/hero_obsidian_destroyer" , LUA_MODIFIER_MOTION_NONE )


npc_dota_hero_obsidian_destroyer_permanent_ability = class({})

function npc_dota_hero_obsidian_destroyer_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_obsidian_destroyer_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_obsidian_destroyer_permanent_ability"
end

function npc_dota_hero_obsidian_destroyer_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_obsidian_destroyer_permanent_ability:IsRefreshable()
	return false 
end

----------------------------------------------------------------------------

modifier_npc_dota_hero_obsidian_destroyer_permanent_ability = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) 
        return {
            MODIFIER_EVENT_ON_TAKEDAMAGE
        } 
    end,
})

function modifier_npc_dota_hero_obsidian_destroyer_permanent_ability:OnTakeDamage(keys)
    if self:GetParent():PassivesDisabled() then return end
    if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() and keys.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
        if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.inflictor then
            self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
            ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)

            keys.attacker:Heal(keys.damage * self:GetAbility():GetSpecialValueFor("lifesteal") * 0.01 * math.ceil((100 - self:GetParent():GetHealthPercent())/20 ),self:GetAbility())
        end
    end
end