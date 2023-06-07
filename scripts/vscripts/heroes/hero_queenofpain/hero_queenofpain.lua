LinkLuaModifier('modifier_npc_dota_hero_queenofpain_permanent_ability', "heroes/hero_queenofpain/hero_queenofpain", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_queenofpain_permanent_ability = class({})

function npc_dota_hero_queenofpain_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_queenofpain_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_queenofpain_permanent_ability"
end

-----------------------------------------------------------------------------------------------

modifier_npc_dota_hero_queenofpain_permanent_ability = class({})

function modifier_npc_dota_hero_queenofpain_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_queenofpain_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_queenofpain_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_queenofpain_permanent_ability:RemoveOnDeath()
	return false
end

function modifier_npc_dota_hero_queenofpain_permanent_ability:OnRemoved()
end

function modifier_npc_dota_hero_queenofpain_permanent_ability:OnDestroy()
end

function modifier_npc_dota_hero_queenofpain_permanent_ability:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_npc_dota_hero_queenofpain_permanent_ability:OnTakeDamage(keys)
	if IsServer() and not self:GetParent():PassivesDisabled() then 
		if keys.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self:GetParent() == keys.unit and not keys.attacker:IsOther() and keys.attacker:GetName() ~= "npc_dota_unit_undying_zombie" and not keys.attacker:IsBuilding() then
			if keys.damage > 50 then
				self.cd = self:GetAbility():GetSpecialValueFor("cd")
				local ability = self:GetParent():FindAbilityByName("queenofpain_scream_of_pain")
				if ability:GetLevel() > 0 and ability:GetCooldownTimeRemaining() > self.cd then
					local left = ability:GetCooldownTimeRemaining() - self.cd
					ability:EndCooldown()
					ability:StartCooldown(left)
				else
					ability:EndCooldown()
				end				
			end
		end
	end
end