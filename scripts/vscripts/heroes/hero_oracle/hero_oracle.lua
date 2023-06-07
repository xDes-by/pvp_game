npc_dota_hero_oracle_permanent_ability = class({})

LinkLuaModifier( "modifier_npc_dota_hero_oracle_permanent_ability","heroes/hero_oracle/hero_oracle" , LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_oracle_permanent_ability_buff","heroes/hero_oracle/hero_oracle" , LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_oracle_false_promise_timer","heroes/hero_oracle/hero_oracle" , LUA_MODIFIER_MOTION_NONE )

function npc_dota_hero_oracle_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_oracle_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_oracle_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_oracle_permanent_ability:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_oracle_permanent_ability"
end

modifier_npc_dota_hero_oracle_permanent_ability = class({})

function modifier_npc_dota_hero_oracle_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_oracle_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_oracle_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_oracle_permanent_ability:OnCreated()
	self:StartIntervalThink(0.2)
end

function modifier_npc_dota_hero_oracle_permanent_ability:OnIntervalThink()
if IsServer() then
	if not self:GetAbility():IsCooldownReady() then return end
		if self:GetParent():PassivesDisabled() then return end
		if self:GetParent():IsAlive() then
			local ally = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetCaster():GetOrigin(),nil,700,DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_HERO,DOTA_UNIT_TARGET_FLAG_NONE,0,false)
			target = ally[1]
			for _,unit in ipairs(ally) do
				if unit:GetHealthPercent() < target:GetHealthPercent() then
					target = unit
				end
			end
			if ally[1] ~= nil then
				self:ApplyFalsePromise(target)
				self:GetAbility():UseResources(false, false, true)
			end 
		end
	end
end

function modifier_npc_dota_hero_oracle_permanent_ability:ApplyFalsePromise(target)
	target:EmitSound("Hero_Oracle.FalsePromise.Target")

	self.false_promise_cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(self.false_promise_cast_particle, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.false_promise_cast_particle)
	
	self.false_promise_target_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast_enemy.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(self.false_promise_target_particle)
	
	self:GetCaster():EmitSound("Hero_Oracle.FalsePromise.Cast")
	
	target:Purge(false, true, false, true, true)
	
	target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_oracle_false_promise_timer", {duration = self:GetAbility():GetSpecialValueFor("duration")})	
end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

modifier_imba_oracle_false_promise_timer = class({})

function modifier_imba_oracle_false_promise_timer:DestroyOnExpire()	return not self:GetParent():IsInvulnerable() end

function modifier_imba_oracle_false_promise_timer:GetPriority()	return MODIFIER_PRIORITY_ULTRA end
function modifier_imba_oracle_false_promise_timer:IsPurgable()	return false end

function modifier_imba_oracle_false_promise_timer:GetTexture()
	return "oracle_false_promise"
end

function modifier_imba_oracle_false_promise_timer:GetEffectName()
	return "particles/units/heroes/hero_oracle/oracle_false_promise.vpcf"
end

function modifier_imba_oracle_false_promise_timer:OnCreated()
	if not IsServer() then return end
	
	self.overhead_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_indicator.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(self.overhead_particle, false, false, -1, true, true)
	
	self.heal_counter		= 0
	
	self.damage_instances	= {}
	self.instance_counter	= 1
	self.damage_counter		= 0
	
end

function modifier_imba_oracle_false_promise_timer:OnRefresh()
	if not IsServer() then return end
	
	self.heal_counter = self.heal_counter or 0

	self.damage_instances	= self.damage_instances or {}
	self.instance_counter	= self.instance_counter or 1
	self.damage_counter		= self.damage_counter or 0

end

function modifier_imba_oracle_false_promise_timer:OnDestroy()
	if not IsServer() then return end
	
	if self.damage_counter < self.heal_counter then
		self:GetParent():EmitSound("Hero_Oracle.FalsePromise.Healed")

		self.end_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(self.end_particle)
		
		self:GetParent():Heal(self.heal_counter - self.damage_counter, self:GetCaster())
		
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), self.heal_counter - self.damage_counter, nil)
	else
		self:GetParent():EmitSound("Hero_Oracle.FalsePromise.Damaged")

		self.end_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(self.end_particle)
	
		for _, instance in pairs(self.damage_instances) do
			if self.heal_counter > 0 then
				if self.heal_counter < instance.damage then
					instance.damage = instance.damage - self.heal_counter
					
					ApplyDamage(instance)
				end
				
				local subtraction_value = math.min(instance.damage, self.heal_counter)
				
				self.heal_counter = self.heal_counter - subtraction_value
				self.damage_counter = self.damage_counter - subtraction_value
			else
				ApplyDamage(instance)
			end
		end

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.damage_counter, nil)
	end
end

function modifier_imba_oracle_false_promise_timer:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_HEAL_RECEIVED,
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_imba_oracle_false_promise_timer:GetModifierIncomingDamage_Percentage(keys)
	if keys.attacker and self:GetRemainingTime() >= 0 then
		self.attacked_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_attacked.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(self.attacked_particle)
	
		local damage_flags = keys.damage_flags
		
		-- "If the heal sum depletes, then the remaining damage instances get applied in order. The damage is flagged as HP Removal."
		if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then
			damage_flags = damage_flags + DOTA_DAMAGE_FLAG_HPLOSS
		end
		
		if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION) ~= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION then
			damage_flags = damage_flags + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
		end
	
		self.damage_instances[self.instance_counter] = {
			victim			= self:GetParent(),
			damage			= keys.damage,
			damage_type		= DAMAGE_TYPE_PURE,
			damage_flags	= damage_flags,
			attacker		= keys.attacker,
			ability			= keys.ability
		}
		
		self.instance_counter = self.instance_counter + 1
		self.damage_counter = self.damage_counter + keys.damage
		
		ParticleManager:SetParticleControl(self.overhead_particle, 1, Vector(self.damage_counter - self.heal_counter, 0, 0))
		ParticleManager:SetParticleControl(self.overhead_particle, 2, Vector(self.heal_counter - self.damage_counter, 0, 0))
		
		self:SetStackCount(math.abs(self.damage_counter - self.heal_counter))
	end
	
	-- Overkill? Meh
	return -99999999
end

function modifier_imba_oracle_false_promise_timer:OnHealReceived(keys)
	if keys.unit == self:GetParent() and self:GetRemainingTime() >= 0 then
		self.heal_counter = self.heal_counter + (keys.gain * 2)
		
		ParticleManager:SetParticleControl(self.overhead_particle, 1, Vector(self.damage_counter - self.heal_counter, 0, 0))
		ParticleManager:SetParticleControl(self.overhead_particle, 2, Vector(self.heal_counter - self.damage_counter, 0, 0))
		
		self:SetStackCount(math.abs(self.damage_counter - self.heal_counter))
	end
end

function modifier_imba_oracle_false_promise_timer:GetDisableHealing(keys)
	return 1
end

function modifier_imba_oracle_false_promise_timer:GetModifierHealthRegenPercentage(keys)
	return self:GetAbility():GetSpecialValueFor("regen")
end

function modifier_imba_oracle_false_promise_timer:GetModifierDamageOutgoing_Percentage(keys)
	return self:GetAbility():GetSpecialValueFor("outgoing") + 100
end