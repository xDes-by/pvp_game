LinkLuaModifier('modifier_npc_dota_hero_slardar_permanent_ability', "heroes/hero_slardar/hero_slardar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_slardar_permanent_ability_debuff', "heroes/hero_slardar/hero_slardar", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_slardar_permanent_ability = class({})

function npc_dota_hero_slardar_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_slardar_permanent_ability'
end

function npc_dota_hero_slardar_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end


modifier_npc_dota_hero_slardar_permanent_ability = class({})

function modifier_npc_dota_hero_slardar_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_slardar_permanent_ability:OnCreated()
	self.count = self:GetAbility():GetSpecialValueFor("count")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

function modifier_npc_dota_hero_slardar_permanent_ability:OnRefresh()
	self:OnCreated()
end

function modifier_npc_dota_hero_slardar_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_npc_dota_hero_slardar_permanent_ability:OnAttackLanded( keys )
	if IsServer() then
		if self:GetParent():PassivesDisabled() then return end
		if self:GetParent() ~= keys.attacker then return end
		if self:GetParent():IsIllusion() then return end
		self:SetStackCount(self:GetStackCount() + 1)
			if self:GetStackCount() >= self.count then	
				if not keys.target:HasModifier("modifier_npc_dota_hero_slardar_permanent_ability_debuff") and not keys.target:IsMagicImmune() then
				keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_npc_dota_hero_slardar_permanent_ability_debuff", {duration = self.duration * (1 - keys.target:GetStatusResistance())})
				self:SetStackCount(0)
			end
		end	
	end
end

------------------------------------------------------------------------------

modifier_npc_dota_hero_slardar_permanent_ability_debuff = class({})

function modifier_npc_dota_hero_slardar_permanent_ability_debuff:IsHidden() return false end
function modifier_npc_dota_hero_slardar_permanent_ability_debuff:IsDebuff() return true end
function modifier_npc_dota_hero_slardar_permanent_ability_debuff:IsPurgable() return true end

function modifier_npc_dota_hero_slardar_permanent_ability_debuff:OnCreated()
	if IsServer() then
		self:PlayEffects()
	end
end

function modifier_npc_dota_hero_slardar_permanent_ability_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE 
	}
end

function modifier_npc_dota_hero_slardar_permanent_ability_debuff:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor("resist")
end

function modifier_npc_dota_hero_slardar_permanent_ability_debuff:GetModifierStatusResistance()
	return self:GetAbility():GetSpecialValueFor("resist")
end

function modifier_npc_dota_hero_slardar_permanent_ability_debuff:PlayEffects()
	self.effect_cast = ParticleManager:CreateParticle( "particles/slardar/slardar_resist.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		0,
		self:GetParent(),
		PATTACH_OVERHEAD_FOLLOW,
		nil,
		self:GetParent():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		1,
		self:GetParent(),
		PATTACH_OVERHEAD_FOLLOW,
		nil,
		self:GetParent():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		2,
		self:GetParent(),
		PATTACH_OVERHEAD_FOLLOW,
		nil,
		self:GetParent():GetOrigin(), -- unknown
		true -- unknown, true
	)
	self:AddParticle(
		self.effect_cast,
		false,
		false,
		-1,
		false,
		true
	)
end