LinkLuaModifier('modifier_npc_dota_hero_enchantress_permanent_ability', "heroes/hero_enchantress/hero_enchantress", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_enchantress_permanent_ability = class({}) 

function npc_dota_hero_enchantress_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_enchantress_permanent_ability:IsStealable()
	return false
end

function npc_dota_hero_enchantress_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_enchantress_permanent_ability:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_enchantress_permanent_ability"
end

------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_enchantress_permanent_ability = class({}) 

function modifier_npc_dota_hero_enchantress_permanent_ability:IsHidden()      return true end
function modifier_npc_dota_hero_enchantress_permanent_ability:IsPurgable()    return false end

function modifier_npc_dota_hero_enchantress_permanent_ability:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK,
    }	
end

function modifier_npc_dota_hero_enchantress_permanent_ability:OnAttack( keys )
    if not IsServer() then return end
    local attacker = self:GetParent()
  
    if attacker ~= keys.attacker then
        return
    end

    if attacker:PassivesDisabled() or attacker:IsIllusion() then
        return
    end

    local target = keys.target

	count = 2
	local range_total = attacker:Script_GetAttackRange()	
	local split_shot_targets = FindUnitsInRadius(self:GetParent():GetTeam(), self:GetParent():GetAbsOrigin(), nil, range_total+100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		if self:GetAbility():IsFullyCastable() then
		 	for _,enemy in pairs(split_shot_targets) do
				if count > 0 then
					count = count - 1
				local projectile_info = 
				{
					EffectName = "particles/econ/items/enchantress/enchantress_virgas/ench_impetus_virgas.vpcf",
					Ability = self:GetAbility(),
					vSpawnOrigin = self:GetParent():GetAbsOrigin(),
					Target = enemy,
					Source = self:GetParent(),
					bHasFrontalCone = false,
					iMoveSpeed = 1200,
					bReplaceExisting = false,
					bProvidesVision = true
				}
				ProjectileManager:CreateTrackingProjectile(projectile_info)                    
				self:GetAbility():UseResources(false,false,true)
				self:GetParent():EmitSound("Hero_Enchantress.Impetus")			
			end
		end
	end
end

function npc_dota_hero_enchantress_permanent_ability:OnProjectileHit( target, location )
    if not IsServer() then return end
    if target then
        local damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())
        ApplyDamage({victim = target, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
    end
    return true
end