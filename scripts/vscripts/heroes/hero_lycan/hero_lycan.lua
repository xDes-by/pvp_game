npc_dota_hero_lycan_permanent_ability = class({})
LinkLuaModifier( "modifier_npc_dota_hero_lycan_permanent_ability","heroes/hero_lycan/hero_lycan", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_lycan_permanent_ability_effect","heroes/hero_lycan/hero_lycan", LUA_MODIFIER_MOTION_NONE )

function npc_dota_hero_lycan_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_lycan_permanent_ability:IsStealable()
	return false
end

function npc_dota_hero_lycan_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_lycan_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_lycan_permanent_ability"
end
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_lycan_permanent_ability = class({})

function modifier_npc_dota_hero_lycan_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_lycan_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_lycan_permanent_ability:OnCreated( kv )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_npc_dota_hero_lycan_permanent_ability:OnRefresh( kv )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_npc_dota_hero_lycan_permanent_ability:OnDestroy( kv )

end

function modifier_npc_dota_hero_lycan_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_npc_dota_hero_lycan_permanent_ability:GetModifierProcAttack_Feedback( params )
if self:GetParent():PassivesDisabled() then return end
if self:GetParent():IsRealHero() and self:GetParent():IsAlive() and not params.target:IsBuilding() and not params.target:IsOther() then
		if IsServer() then
			params.target:AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_npc_dota_hero_lycan_permanent_ability_effect",
			{ duration = self.duration }
			)
		end
	end
end

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

modifier_npc_dota_hero_lycan_permanent_ability_effect = class({})

function modifier_npc_dota_hero_lycan_permanent_ability_effect:IsHidden()
	return false
end

function modifier_npc_dota_hero_lycan_permanent_ability_effect:IsDebuff()
	return true
end

function modifier_npc_dota_hero_lycan_permanent_ability_effect:IsStunDebuff()
	return false
end

function modifier_npc_dota_hero_lycan_permanent_ability_effect:IsPurgable()
	return true
end

function modifier_npc_dota_hero_lycan_permanent_ability_effect:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "hp" )/10
	self:StartIntervalThink( 0.1 )
end

function modifier_npc_dota_hero_lycan_permanent_ability_effect:OnRefresh( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "hp" )/10
end

function modifier_npc_dota_hero_lycan_permanent_ability_effect:OnIntervalThink()
self:OnRefresh()
	if not IsServer() then return end
	SendOverheadEventMessage( self:GetParent():GetPlayerOwner(), OVERHEAD_ALERT_DAMAGE  ,self:GetParent(), self.damage, nil )
	
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(),
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}
	ApplyDamage( self.damageTable )
end

function modifier_npc_dota_hero_lycan_permanent_ability_effect:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/blood_gore_arterial_drip_2.vpcf"
end

function modifier_npc_dota_hero_lycan_permanent_ability_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end