npc_dota_hero_techies_permanent_ability = class({})

LinkLuaModifier('modifier_npc_dota_hero_techies_permanent_ability', "heroes/hero_techies/hero_techies", LUA_MODIFIER_MOTION_NONE)

function npc_dota_hero_techies_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_techies_permanent_ability:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_techies_permanent_ability"
end

modifier_npc_dota_hero_techies_permanent_ability = class({
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
    OnTakeDamage = function(self,data) 
    if self:GetParent():PassivesDisabled() then return end
        if RandomInt(1,100) >= self:GetAbility():GetSpecialValueFor("chance") then return end
        if data.unit == self:GetParent() and not data.attacker:IsBuilding() and not data.attacker:IsOther() and data.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
	        data.attacker:AddNewModifier(target,self,"modifier_stunned",{ duration = self:GetAbility():GetSpecialValueFor("duration")})
            ApplyDamage({ victim = data.attacker, attacker = self:GetParent(), damage = self:GetAbility():GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL })
            local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_CUSTOMORIGIN, nil)
		    ParticleManager:SetParticleControl(pfx, 0, data.attacker:GetAbsOrigin())
		    ParticleManager:SetParticleControl(pfx, 2, Vector(50,50,50))
        end
    end,
})
