LinkLuaModifier( "modifier_npc_dota_hero_kunkka_permanent_ability", "heroes/hero_kunkka/hero_kunkka", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dummy", "modifiers/modifier_dummy", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_kunkka_permanent_ability = class({})

function npc_dota_hero_kunkka_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_kunkka_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_kunkka_permanent_ability"
end

function npc_dota_hero_kunkka_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_kunkka_permanent_ability:IsRefreshable()
	return false 
end

----------------------------------------------------------------------------

modifier_npc_dota_hero_kunkka_permanent_ability = class({})

function modifier_npc_dota_hero_kunkka_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_kunkka_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_kunkka_permanent_ability:OnCreated( kv )
	self:StartIntervalThink(1)
end

function modifier_npc_dota_hero_kunkka_permanent_ability:OnIntervalThink()
if IsServer() and self:GetAbility() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() and not self:GetCaster():PassivesDisabled()  then
	if self:GetAbility():IsCooldownReady() then
		local duration = self:GetAbility():GetSpecialValueFor("duration")
		local damage = self:GetAbility():GetSpecialValueFor("damage")
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local range = 800
		local caster_pos = self:GetCaster():GetAbsOrigin()

		local particle_pre = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_fxset.vpcf"
		local particle = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf"
		
		local angle = RandomInt(0, 360)
		local variance = RandomInt(-range, range)
		local dy = math.sin(angle) * variance
		local dx = math.cos(angle) * variance
		local target_pos = Vector(caster_pos.x + dx, caster_pos.y + dy, caster_pos.z)
		local dummy = CreateUnitByName("npc_dummy_unit", target_pos, false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
		dummy:AddNewModifier(self:GetCaster(),self,"modifier_dummy",{} )
		local particleIndexPre = ParticleManager:CreateParticle(particle_pre, PATTACH_ABSORIGIN, dummy)

		Timers:CreateTimer(0.5, function()
				self:GetCaster():EmitSound("Ability.Torrent")
				ParticleManager:DestroyParticle( particleIndexPre, false )
				local particleIndex = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, dummy)
				local units = FindUnitsInRadius(self:GetCaster():GetTeam(), target_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
				for k, unit in ipairs(units) do
					local damage_table = {
											attacker = self:GetCaster(),
											victim = unit,
											ability = self:GetAbility(),
											damage_type = self:GetAbility():GetAbilityDamageType(),
											damage = damage
										}
					ApplyDamage(damage_table)
					unit:AddNewModifier(self:GetCaster(),self,"modifier_stunned",{ duration = self:GetAbility():GetSpecialValueFor("duration") * (1 - unit:GetStatusResistance())}	)
				end
				dummy:ForceKill(false)
			end)
			
			self:GetAbility():UseResources(false, false, true)
		end
	end
end