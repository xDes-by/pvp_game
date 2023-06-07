LinkLuaModifier( "modifier_npc_dota_hero_tiny_permanent_ability", "heroes/hero_tiny/hero_tiny", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_tiny_permanent_ability = class({})

function npc_dota_hero_tiny_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_tiny_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_tiny_permanent_ability"
end

---------------------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_tiny_permanent_ability = class({})

function modifier_npc_dota_hero_tiny_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_tiny_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_tiny_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_tiny_permanent_ability:RemoveOnDeath()
	return false
end


function modifier_npc_dota_hero_tiny_permanent_ability:OnCreated( kv )
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_npc_dota_hero_tiny_permanent_ability:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_npc_dota_hero_tiny_permanent_ability:OnRemoved()
end

function modifier_npc_dota_hero_tiny_permanent_ability:OnDestroy()
end

function modifier_npc_dota_hero_tiny_permanent_ability:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_npc_dota_hero_tiny_permanent_ability:OnTakeDamage(keys)
	if IsServer() and not self:GetParent():PassivesDisabled() then 
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		if keys.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self:GetParent() == keys.unit and not keys.attacker:IsOther() and keys.attacker:GetName() ~= "npc_dota_unit_undying_zombie" and not keys.attacker:IsBuilding() then
			if keys.damage_category == 1 then
				if RandomInt(1,100) <= self.chance then
				keys.attacker:AddNewModifier(self:GetCaster(),self,"modifier_stunned",{ duration = self.duration * (1 - keys.attacker:GetStatusResistance())})
				ApplyDamage({
					victim = keys.attacker,
					attacker = self:GetParent(),
					damage = self.damage,
					damage_type = keys.damage_type,
					damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
					ability = self:GetAbility()
				})
				end
			end
		end
	end
end