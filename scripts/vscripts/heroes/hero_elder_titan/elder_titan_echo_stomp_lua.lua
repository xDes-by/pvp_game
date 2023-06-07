elder_titan_echo_stomp_lua = class({})

function elder_titan_echo_stomp_lua:GetBehavior()
	local behavior = DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED
	if self:GetCaster():HasShard() then
		behavior = behavior + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end

	return behavior
end

function elder_titan_echo_stomp_lua:OnAbilityPhaseStart()
	if not self or self:IsNull() or not self:GetCaster() or self:GetCaster():IsNull() then return false end

	local caster = self:GetCaster()
	if caster.astral_spirit and not caster.astral_spirit:IsNull() and caster.astral_spirit:FindAbilityByName("elder_titan_echo_stomp_spirit_lua") then
		caster.astral_spirit:CastAbilityNoTarget(caster.astral_spirit:FindAbilityByName("elder_titan_echo_stomp_spirit_lua"), caster.astral_spirit:GetPlayerOwnerID())
	end

	return true
end

function elder_titan_echo_stomp_lua:OnAbilityPhaseInterrupted()
	if not self or self:IsNull() or not self:GetCaster() or self:GetCaster():IsNull() then return end
	local caster = self:GetCaster()
	if caster.astral_spirit and not caster.astral_spirit:IsNull() then
		caster.astral_spirit:Interrupt()
	end
end

function elder_titan_echo_stomp_lua:OnSpellStart()
	if not self or self:IsNull() or not self:GetCaster() or self:GetCaster():IsNull() then return end
	local caster = self:GetCaster()
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	if not (caster.astral_spirit and not caster.astral_spirit:IsNull()) then
		self.combined_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_cast_combined.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	end

	EmitSoundOn("Hero_ElderTitan.EchoStomp.Channel", caster)
end

function elder_titan_echo_stomp_lua:OnChannelFinish(interrupted)
	if IsServer() then
		if not self or self:IsNull() or not self:GetCaster() or self:GetCaster():IsNull() then return end
		local caster = self:GetCaster()

		if self.combined_particle then
			ParticleManager:DestroyParticle(self.combined_particle, true)
			ParticleManager:ReleaseParticleIndex(self.combined_particle)
		end

		caster:FadeGesture(ACT_DOTA_CAST_ABILITY_1)

		if interrupted then
			if caster.astral_spirit and not caster.astral_spirit:IsNull() and not caster.astral_spirit.is_returning then
				caster.astral_spirit:Interrupt()
			end
		else
			-- Ability specials
			local radius = self:GetSpecialValueFor("radius")
			local stun_duration = self:GetSpecialValueFor("sleep_duration")
			local stomp_damage = self:GetSpecialValueFor("stomp_damage") + caster:FindTalentValue("special_bonus_unique_elder_titan_2")

			-- Play cast sound
			EmitSoundOn("Hero_ElderTitan.EchoStomp.ti7", caster)
			EmitSoundOn("Hero_ElderTitan.EchoStomp.ti7_layer", caster)

			-- Add stomp particle
			local particle_stomp_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_physical.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(particle_stomp_fx, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_stomp_fx, 1, Vector(radius, 1, 1))
			ParticleManager:SetParticleControl(particle_stomp_fx, 2, caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_stomp_fx)

			if not (caster.astral_spirit and not caster.astral_spirit:IsNull()) then
				local magical_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_magical.vpcf", PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(magical_particle, 2, caster:GetAbsOrigin())
				ParticleManager:SetParticleControl(magical_particle, 1, Vector(radius, 1, 1))
				ParticleManager:ReleaseParticleIndex(magical_particle)
			end

			-- Find all nearby enemies
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

			for _, enemy in pairs(enemies) do
				ApplyDamage({
					victim = enemy,
					attacker = caster,
					damage = stomp_damage,
					damage_type = self:GetAbilityDamageType(),
					ability = self
				})

				if not caster.astral_spirit or caster.astral_spirit:IsNull() then
					ApplyDamage({
						victim = enemy,
						attacker = caster,
						damage = stomp_damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self
					})
				end

				-- Stun them
				enemy:AddNewModifier(caster, self, "modifier_elder_titan_echo_stomp", {duration = stun_duration * (1 - enemy:GetStatusResistance())})
			end

			if self:GetAutoCastState() and (caster.astral_spirit and not caster.astral_spirit:IsNull()) then
				caster:SetAbsOrigin(caster.astral_spirit:GetAbsOrigin())
			end
		end
	end
end
