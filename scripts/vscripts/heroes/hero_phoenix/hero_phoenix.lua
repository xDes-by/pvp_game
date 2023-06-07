LinkLuaModifier( "modifier_npc_dota_hero_phoenix_permanent_ability", "heroes/hero_phoenix/hero_phoenix", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_phoenix_permanent_ability_fire", "heroes/hero_phoenix/hero_phoenix", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_phoenix_permanent_ability = class({})

function npc_dota_hero_phoenix_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_phoenix_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_phoenix_permanent_ability"
end

function npc_dota_hero_phoenix_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_phoenix_permanent_ability:IsRefreshable()
	return false 
end

---------------------------------------------------------------------------------------

modifier_npc_dota_hero_phoenix_permanent_ability = class({})

function modifier_npc_dota_hero_phoenix_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_phoenix_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_phoenix_permanent_ability:DeclareFunctions()
	return {
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_npc_dota_hero_phoenix_permanent_ability:OnTakeDamage( params )
	if not IsServer() then return end

	if params.unit~=self:GetParent() then return end
	if self:GetParent():PassivesDisabled() then return end
	if params.attacker:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	params.attacker:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_npc_dota_hero_phoenix_permanent_ability_fire", { duration = self:GetAbility():GetSpecialValueFor( "duration" ) * (1 - params.attacker:GetStatusResistance())}	)

	--local sound_cast = "Hero_OgreMagi.Ignite.Target"
--	EmitSoundOn( sound_cast, params.attacker )
end

--------------------------------------------------------------------------------------

modifier_npc_dota_hero_phoenix_permanent_ability_fire = class({})

function modifier_npc_dota_hero_phoenix_permanent_ability_fire:IsHidden()
	return false
end

function modifier_npc_dota_hero_phoenix_permanent_ability_fire:IsDebuff()
	return true
end

function modifier_npc_dota_hero_phoenix_permanent_ability_fire:IsStunDebuff()
	return false
end

function modifier_npc_dota_hero_phoenix_permanent_ability_fire:IsPurgable()
	return true
end

function modifier_npc_dota_hero_phoenix_permanent_ability_fire:OnCreated( kv )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if not IsServer() then return end
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
	}
	
	self:StartIntervalThink( 1 )
end

function modifier_npc_dota_hero_phoenix_permanent_ability_fire:OnRefresh( kv )
	self.slow = -self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if not IsServer() then return end
	self.damageTable.damage = damage
end


function modifier_npc_dota_hero_phoenix_permanent_ability_fire:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

function modifier_npc_dota_hero_phoenix_permanent_ability_fire:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_debuff.vpcf"
end

function modifier_npc_dota_hero_phoenix_permanent_ability_fire:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end