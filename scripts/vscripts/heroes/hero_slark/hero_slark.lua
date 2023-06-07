LinkLuaModifier('modifier_npc_dota_hero_slark_permanent_ability', "heroes/hero_slark/hero_slark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_slark_permanent_ability_debuff', "heroes/hero_slark/hero_slark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_slark_permanent_ability_stack', "heroes/hero_slark/hero_slark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_slark_permanent_ability_kill_debuff', "heroes/hero_slark/hero_slark", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_slark_permanent_ability = class({})

function npc_dota_hero_slark_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_slark_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_slark_permanent_ability'
end

modifier_npc_dota_hero_slark_permanent_ability = {}

function modifier_npc_dota_hero_slark_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_slark_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_slark_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_slark_permanent_ability:OnCreated( kv )
	self.agi_gain = self:GetAbility():GetSpecialValueFor( "steal" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
    self.chance = self:GetAbility():GetSpecialValueFor("chance")
end

modifier_npc_dota_hero_slark_permanent_ability.OnRefresh = modifier_npc_dota_hero_slark_permanent_ability.OnCreated

function modifier_npc_dota_hero_slark_permanent_ability:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_EVENT_ON_RESPAWN
	}
end

function modifier_npc_dota_hero_slark_permanent_ability:GetModifierProcAttack_Feedback( params )
	if IsServer() and not self:GetParent():PassivesDisabled() then
		local target = params.target
        if RandomInt(1,100) <= self.chance then 
            if not target:IsHero() or target:IsIllusion() then
                return
            end

            local debuff = params.target:AddNewModifier(
                self:GetParent(),
                self:GetAbility(),
                "modifier_npc_dota_hero_slark_permanent_ability_debuff",
                {
                    stack_duration = self.duration,
                }
            )

            self:AddStack( duration )

            self:PlayEffects( params.target )
        end
	end
end

function modifier_npc_dota_hero_slark_permanent_ability:GetModifierBonusStats_Intellect()
	return self:GetStackCount() * self.agi_gain
end

function modifier_npc_dota_hero_slark_permanent_ability:GetModifierBonusStats_Strength()
	return self:GetStackCount() * self.agi_gain
end

function modifier_npc_dota_hero_slark_permanent_ability:OnRespawn(data)
	if data.unit:HasModifier("modifier_slark_essence_shift_permanent_debuff") then
        data.unit:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_npc_dota_hero_slark_permanent_ability_kill_debuff",{})
        local stacks = data.unit:FindModifierByName("modifier_slark_essence_shift_permanent_debuff"):GetStackCount()
        data.unit:FindModifierByName("modifier_npc_dota_hero_slark_permanent_ability_kill_debuff"):SetStackCount(stacks)
    end
end

function modifier_npc_dota_hero_slark_permanent_ability:AddStack( duration )
	local mod = self:GetParent():AddNewModifier(
		self:GetParent(),
		self:GetAbility(),
		"modifier_npc_dota_hero_slark_permanent_ability_stack",
		{
			duration = self.duration,
		}
	)
	mod.modifier = self

	self:IncrementStackCount()
end

function modifier_npc_dota_hero_slark_permanent_ability:RemoveStack()
	self:DecrementStackCount()
end

function modifier_npc_dota_hero_slark_permanent_ability:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_slark/slark_essence_shift.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() + Vector( 0, 0, 64 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
------------------------------------------------------------------------------
modifier_npc_dota_hero_slark_permanent_ability_debuff = {}

function modifier_npc_dota_hero_slark_permanent_ability_debuff:IsHidden()
	return false
end

function modifier_npc_dota_hero_slark_permanent_ability_debuff:IsDebuff()
	return true
end

function modifier_npc_dota_hero_slark_permanent_ability_debuff:IsPurgable()
	return false
end

function modifier_npc_dota_hero_slark_permanent_ability_debuff:OnCreated( kv )
	self.stat_loss = self:GetAbility():GetSpecialValueFor( "steal" )
	self.duration = kv.stack_duration

	if IsServer() then
		self:AddStack( self.duration )
	end
end

function modifier_npc_dota_hero_slark_permanent_ability_debuff:OnRefresh( kv )
	self.stat_loss = self:GetAbility():GetSpecialValueFor( "steal" )
	self.duration = kv.stack_duration

	if IsServer() then
		self:AddStack( self.duration )
	end
end

function modifier_npc_dota_hero_slark_permanent_ability_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

function modifier_npc_dota_hero_slark_permanent_ability_debuff:GetModifierBonusStats_Strength()
	return self:GetStackCount() * -self.stat_loss
end

function modifier_npc_dota_hero_slark_permanent_ability_debuff:GetModifierBonusStats_Intellect()
	return self:GetStackCount() * -self.stat_loss
end

function modifier_npc_dota_hero_slark_permanent_ability_debuff:AddStack( duration )
	local mod = self:GetParent():AddNewModifier(
		self:GetParent(),
		self:GetAbility(),
		"modifier_npc_dota_hero_slark_permanent_ability_stack",
		{
			duration = self.duration,
		}
	)
	mod.modifier = self

	self:IncrementStackCount()
end

function modifier_npc_dota_hero_slark_permanent_ability_debuff:RemoveStack()
	self:DecrementStackCount()

	if self:GetStackCount()<=0 then
		self:Destroy()
	end
end

modifier_npc_dota_hero_slark_permanent_ability_stack = {}

function modifier_npc_dota_hero_slark_permanent_ability_stack:IsHidden()
	return true
end

function modifier_npc_dota_hero_slark_permanent_ability_stack:IsPurgable()
	return false
end
function modifier_npc_dota_hero_slark_permanent_ability_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_npc_dota_hero_slark_permanent_ability_stack:OnCreated( kv )
end

function modifier_npc_dota_hero_slark_permanent_ability_stack:OnRemoved()
	if IsServer() then
		self.modifier:RemoveStack()
	end
end

modifier_npc_dota_hero_slark_permanent_ability_kill_debuff = {}

function modifier_npc_dota_hero_slark_permanent_ability_kill_debuff:IsHidden()
	return true
end

function modifier_npc_dota_hero_slark_permanent_ability_kill_debuff:IsDebuff()
	return false
end

function modifier_npc_dota_hero_slark_permanent_ability_kill_debuff:IsPurgable()
	return false
end

function modifier_npc_dota_hero_slark_permanent_ability_kill_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

function modifier_npc_dota_hero_slark_permanent_ability_kill_debuff:GetModifierBonusStats_Strength()
	return self:GetStackCount() * -1
end

function modifier_npc_dota_hero_slark_permanent_ability_kill_debuff:GetModifierBonusStats_Intellect()
	return self:GetStackCount() * -1
end