elder_titan_echo_stomp_spirit_lua = class({})

function elder_titan_echo_stomp_spirit_lua:OnAbilityPhaseStart()
	if not self or self:IsNull() or not self:GetCaster() or self:GetCaster():IsNull() then return false end
	local caster = self:GetCaster():GetOwner()
	local caster_ability = caster:FindAbilityByName("elder_titan_echo_stomp_lua")
	if caster and not caster:IsNull() and caster_ability and not caster_ability:IsInAbilityPhase() then
		caster:CastAbilityNoTarget(caster:FindAbilityByName("elder_titan_echo_stomp_lua"), caster:GetPlayerOwnerID())
	end

	return true
end

function elder_titan_echo_stomp_spirit_lua:OnSpellStart()
	if not self or self:IsNull() or not self:GetCaster() or self:GetCaster():IsNull() then return end

	local caster = self:GetCaster()
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	EmitSoundOn("Hero_ElderTitan.EchoStomp.Channel", caster)
end

function elder_titan_echo_stomp_spirit_lua:OnChannelFinish(interrupted)
	if IsServer() then
		if not self or self:IsNull() or not self:GetCaster() or self:GetCaster():IsNull() then return end
		local caster = self:GetCaster()
		local caster_owner = caster:GetOwner()

		caster:FadeGesture(ACT_DOTA_CAST_ABILITY_1)

		if not interrupted then
			-- Ability specials
			local radius = self:GetSpecialValueFor("radius")
			local stun_duration = self:GetSpecialValueFor("sleep_duration")
			local stomp_damage = self:GetSpecialValueFor("stomp_damage") + caster_owner:FindTalentValue("special_bonus_unique_elder_titan_2")

			-- Play cast sound
			EmitSoundOn("Hero_ElderTitan.EchoStomp.ti7", caster)
			EmitSoundOn("Hero_ElderTitan.EchoStomp.ti7_layer", caster)

			-- Add stomp particle
			local magical_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_magical.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(magical_particle, 2, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(magical_particle, 1, Vector(radius, 1, 1))
			ParticleManager:ReleaseParticleIndex(magical_particle)

			-- Find all nearby enemies
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

			for _, enemy in pairs(enemies) do
				ApplyDamage({
					victim = enemy,
					attacker = caster_owner,
					damage = stomp_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self
				})

				-- Stun them
				enemy:AddNewModifier(caster_owner, self, "modifier_elder_titan_echo_stomp", {duration = stun_duration * (1 - enemy:GetStatusResistance())})
			end
		end
	end
end
