LinkLuaModifier( "modifier_npc_dota_hero_vengefulspirit_permanent_ability", "heroes/hero_vengefulspirit/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_vengefulspirit_permanent_ability = class({})

function npc_dota_hero_vengefulspirit_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_vengefulspirit_permanent_ability:IsStealable()
	return false
end

function npc_dota_hero_vengefulspirit_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_vengefulspirit_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_vengefulspirit_permanent_ability"
end
--------------------------------------------------------------------------------------------

modifier_npc_dota_hero_vengefulspirit_permanent_ability = class({})

function modifier_npc_dota_hero_vengefulspirit_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_vengefulspirit_permanent_ability:OnCreated()
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
end

function modifier_npc_dota_hero_vengefulspirit_permanent_ability:OnRefresh()
	self:OnCreated()
end

function modifier_npc_dota_hero_vengefulspirit_permanent_ability:DeclareFunctions() 
return {
	MODIFIER_PROPERTY_ABSORB_SPELL,
}
end

function modifier_npc_dota_hero_vengefulspirit_permanent_ability:GetAbsorbSpell(params)
	if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then
		return nil
	end
	if self:GetCaster():PassivesDisabled() then return end
	if RandomInt(1,100) <= self.chance then
		self:GetParent():EmitSound("Hero_VengefulSpirit.NetherSwap")	
		local line_pos = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * 150
		if RandomInt(1,2) == 1 then
			self.motion = 90
		else
			self.motion = 270
		end
		point = RotatePosition(self:GetCaster():GetAbsOrigin(), QAngle(0, self.motion, 0), line_pos)
		self:GetCaster():SetAbsOrigin( point )
		FindClearSpaceForUnit(self:GetCaster(), point, false)	
		
			local info = {
			EffectName = "particles/units/heroes/hero_vengeful/vengeful_magic_missle.vpcf",
			Ability = self:GetAbility(),
			iMoveSpeed = 1250,
			Source = self:GetCaster(),
			Target = params.ability:GetCaster(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

		ProjectileManager:CreateTrackingProjectile( info )
		EmitSoundOn( "Hero_VengefulSpirit.MagicMissile", self:GetCaster() )
		
		return 1
	end
	return 0
end

function npc_dota_hero_vengefulspirit_permanent_ability:OnProjectileHit( hTarget, vLocation )
		if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
			EmitSoundOn( "Hero_VengefulSpirit.MagicMissileImpact", hTarget )

			local damage = {
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self:GetCaster():GetBaseDamageMin(),
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self
			}

			ApplyDamage( damage )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("stun") * (1 - hTarget:GetStatusResistance())} )
		end
	return true
end