LinkLuaModifier( "modifier_npc_dota_hero_earth_spirit_permanent_ability", "heroes/hero_earth_spirit/hero_earth_spirit", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_earth_spirit_permanent_ability = class({})

function npc_dota_hero_earth_spirit_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_earth_spirit_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_earth_spirit_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_earth_spirit_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_earth_spirit_permanent_ability"
end

---------------------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_earth_spirit_permanent_ability = class({})

function modifier_npc_dota_hero_earth_spirit_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_earth_spirit_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_earth_spirit_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_earth_spirit_permanent_ability:RemoveOnDeath()
	return false
end

function modifier_npc_dota_hero_earth_spirit_permanent_ability:OnCreated( kv )
	self.range = self:GetAbility():GetSpecialValueFor( "range" )
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
	self.crit = self:GetAbility():GetSpecialValueFor( "crit" )	
end

function modifier_npc_dota_hero_earth_spirit_permanent_ability:OnRefresh( kv )
	self.range = self:GetAbility():GetSpecialValueFor( "range" )
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
	self.crit = self:GetAbility():GetSpecialValueFor( "crit" )
end

function modifier_npc_dota_hero_earth_spirit_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_npc_dota_hero_earth_spirit_permanent_ability:OnAttackLanded( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end
		if self.record and self.record == params.record then
		self.record = nil
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_knockback", {
					center_x			= self:GetParent():GetAbsOrigin()[1] + 1,
					center_y			= self:GetParent():GetAbsOrigin()[2] + 1,
					center_z			= self:GetParent():GetAbsOrigin()[3],
					duration			= 0.4 * (1 - params.target:GetStatusResistance()),
					knockback_duration	= 0.4 * (1 - params.target:GetStatusResistance()),
					knockback_distance	= self:GetAbility():GetSpecialValueFor( "range" ),
					knockback_height	= 0,
					should_stun			= 0
				})
		end
	end
end

function modifier_npc_dota_hero_earth_spirit_permanent_ability:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end
		if RandomInt(0, 100)< self.chance then
			self.record = params.record
			return self.crit
		end
	end
end

function modifier_npc_dota_hero_earth_spirit_permanent_ability:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record and self.record == params.record then
			
			local sound_cast = "Hero_Juggernaut.BladeDance"
			EmitSoundOn( sound_cast, params.target )
		end
	end
end