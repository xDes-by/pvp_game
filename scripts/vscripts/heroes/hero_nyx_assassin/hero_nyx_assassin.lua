npc_dota_hero_nyx_assassin_permanent_ability = class({})

LinkLuaModifier('modifier_npc_dota_hero_nyx_assassin_permanent_ability', "heroes/hero_nyx_assassin/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_furion_permanent_ability_summon', "heroes/hero_nyx_assassin/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)

function npc_dota_hero_nyx_assassin_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_nyx_assassin_permanent_ability:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_nyx_assassin_permanent_ability"
end

modifier_npc_dota_hero_nyx_assassin_permanent_ability = class({
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
						local length = ( self:GetParent():GetOrigin() - data.attacker:GetOrigin() ):Length2D()
						local direction = (data.attacker:GetOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
				
						ProjectileManager:CreateLinearProjectile({
						Ability = self:GetAbility(),
						EffectName = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_impale.vpcf",
						vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
						fDistance = length,
						fStartRadius = 125,
						fEndRadius = 125,
						Source = self:GetParent(),
						bHasFrontalCone = false,
						bReplaceExisting = false,
						iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
						iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						bDeleteOnHit = false,
						vVelocity = direction * 1300 * Vector(1, 1, 0),
						bProvidesVision = false,
						ExtraData = { main_spike = true }
					})
					self:GetAbility():UseResources(false, false, true)
				end
			end
		end
    end,
})

function npc_dota_hero_nyx_assassin_permanent_ability:OnProjectileHit_ExtraData(target, location, ExtraData)
	if not target then
		return nil
	end
	if target:IsMagicImmune() then
		return nil
	end
	target:AddNewModifier(target,nil,"modifier_stunned",{ duration = 1 * (1 - target:GetStatusResistance())})
	self:GetCaster():PerformAttack(target, false, true, true, false, false, false, true)
end