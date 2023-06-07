LinkLuaModifier( "modifier_npc_dota_hero_tusk_permanent_ability", "heroes/hero_tusk/hero_tusk", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_tusk_permanent_ability = class({})

function npc_dota_hero_tusk_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_tusk_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_tusk_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_tusk_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_tusk_permanent_ability"
end

--------------------------------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_tusk_permanent_ability = class({})

function modifier_npc_dota_hero_tusk_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_tusk_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_tusk_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_tusk_permanent_ability:RemoveOnDeath()
	return false
end

function modifier_npc_dota_hero_tusk_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_npc_dota_hero_tusk_permanent_ability:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end
		if RandomInt(0, 100) <= self:GetAbility():GetSpecialValueFor( "chance" ) then
			self.record = params.record
			return self:GetAbility():GetSpecialValueFor( "damage" )
		end
	end
end

function modifier_npc_dota_hero_tusk_permanent_ability:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record and self.record == params.record then
			self.record = nil
			local pos = self:GetParent():GetAbsOrigin()
				EmitSoundOn("Hero_Tusk.WalrusPunch.Target", self:GetCaster()) 
				local p= ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_attack_normal_punch.vpcf", PATTACH_ABSORIGIN,self:GetParent())
                ParticleManager:SetParticleControl(p, 0,pos)
                ParticleManager:SetParticleControl(p, 2,pos)
                ParticleManager:ReleaseParticleIndex( p )
		end
	end
end