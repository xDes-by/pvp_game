
LinkLuaModifier('modifier_npc_dota_hero_templar_assassin_permanent_ability', "heroes/hero_templar_assassin/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_templar_assassin_permanent_ability = class({})

function npc_dota_hero_templar_assassin_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_templar_assassin_permanent_ability'
end

function npc_dota_hero_templar_assassin_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

--------------------------------------------------------------------------------

modifier_npc_dota_hero_templar_assassin_permanent_ability = class({})

function modifier_npc_dota_hero_templar_assassin_permanent_ability:IsHidden()
    return true
end

function modifier_npc_dota_hero_templar_assassin_permanent_ability:IsDebuff( kv )
	return false
end

function modifier_npc_dota_hero_templar_assassin_permanent_ability:IsPurgable( kv )
	return false
end


function modifier_npc_dota_hero_templar_assassin_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE 
	}
	return funcs
end

function modifier_npc_dota_hero_templar_assassin_permanent_ability:GetModifierDamageOutgoing_Percentage(data)
    if self.splitTarget == data.target then
        return (100 - self:GetAbility():GetSpecialValueFor("uron")) * -1
    end
end

function modifier_npc_dota_hero_templar_assassin_permanent_ability:OnAttack( params )
	if IsServer() then
		pass = false
		if params.attacker==self:GetParent() then
			pass = true
		end
		if pass then
			local caster = params.attacker
			local target = params.target
			local ability = self
			local attack_range = caster:Script_GetAttackRange() + 100
			local arrow_count = 1
			
			self.attack = caster:GetAttackCapability()
			if self.attack == DOTA_UNIT_CAP_RANGED_ATTACK then
			
			if ability ~= nil then 

			local units = FindUnitsInRadius(caster:GetTeamNumber(), 
											caster:GetAbsOrigin(),
											nil,
											attack_range,
											DOTA_UNIT_TARGET_TEAM_ENEMY,
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
											DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
											FIND_CLOSEST, 
											false) 
			
			if ability.split == nil then
				ability.split = true
			elseif ability.split == false then
				return
			end
			
			ability.split = false 
			if arrow_count > #units-1  then 
				arrow_count = #units-1
			end

			local index = 1
			local arrow_deal = 0
			self.splitTarget = units[ index ]
			while arrow_deal < arrow_count   do
				if units[index] == target then
				else
					caster:PerformAttack(units[ index ], true, true, true, false, true, false, false)
					arrow_deal = arrow_deal + 1
				end	
				index = index + 1
			end
			
			ability.split = true	
			end
		end
	end
	end
end