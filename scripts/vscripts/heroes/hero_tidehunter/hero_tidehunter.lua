npc_dota_hero_tidehunter_permanent_ability = class({})

LinkLuaModifier('modifier_npc_dota_hero_tidehunter_permanent_ability', "heroes/hero_tidehunter/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)

function npc_dota_hero_tidehunter_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_tidehunter_permanent_ability:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_tidehunter_permanent_ability"
end

modifier_npc_dota_hero_tidehunter_permanent_ability = class({
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
        if RandomInt(1,100) <= self:GetAbility():GetSpecialValueFor("chance") then
		if self:GetAbility():IsCooldownReady() then
			if data.unit == self:GetParent() and self:GetParent():IsRealHero() and self:GetParent():IsAlive() and not data.attacker:IsBuilding() and not data.attacker:IsOther() and data.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not self:GetParent():PassivesDisabled() and data.damage_category == 1 then
				self:GetCaster():EmitSound("Ability.Torrent")
				local particleIndex = ParticleManager:CreateParticle("particles/econ/items/tidehunter/tide_2021_immortal/tide_2021_ravage_hit.vpcf", PATTACH_ABSORIGIN, data.attacker)
				local units = FindUnitsInRadius(self:GetCaster():GetTeam(), data.attacker:GetAbsOrigin(), nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
				for k, unit in ipairs(units) do
					local damage_table = {
											attacker = self:GetCaster(),
											victim = unit,
											ability = self:GetAbility(),
											damage_type = self:GetAbility():GetAbilityDamageType(),
											damage = self:GetCaster():GetBaseDamageMin()
										}
					local knockback =
					{
						knockback_duration = 0.5 * (1 - unit:GetStatusResistance()),
						duration = 0.5 * (1 - unit:GetStatusResistance()),
						knockback_distance = 0,
						knockback_height = 350,
					}
					unit:RemoveModifierByName("modifier_knockback")
					unit:AddNewModifier(self:GetCaster(), self, "modifier_knockback", knockback)
					
					ApplyDamage(damage_table)
					unit:AddNewModifier(self:GetCaster(),self,"modifier_stunned",{ duration = self:GetAbility():GetSpecialValueFor("duration") * (1 - unit:GetStatusResistance())})
				end
			end
		end
		end
    end,
})