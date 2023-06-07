-- Astral Spirit
elder_titan_ancestral_spirit_lua = class({})
LinkLuaModifier("modifier_elder_titan_ancestral_spirit_lua", "heroes/hero_elder_titan/modifier_elder_titan_ancestral_spirit_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elder_titan_ancestral_spirit_lua_damage", "heroes/hero_elder_titan/modifier_elder_titan_ancestral_spirit_buffs_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elder_titan_ancestral_spirit_lua_ms", "heroes/hero_elder_titan/modifier_elder_titan_ancestral_spirit_buffs_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elder_titan_ancestral_spirit_lua_armor", "heroes/hero_elder_titan/modifier_elder_titan_ancestral_spirit_buffs_lua", LUA_MODIFIER_MOTION_NONE)

function elder_titan_ancestral_spirit_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()

	EmitSoundOn("Hero_ElderTitan.AncestralSpirit.Cast", caster)
	caster:SwapAbilities("elder_titan_ancestral_spirit_lua", "elder_titan_return_spirit_lua", false, true)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_cast.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 2, target_point)
	ParticleManager:ReleaseParticleIndex(particle)

	caster.astral_spirit = CreateUnitByName("npc_dota_elder_titan_ancestral_spirit", target_point, true, caster, caster, caster:GetTeamNumber())
	caster.astral_spirit:SetControllableByPlayer(caster:GetPlayerID(), true)
	caster.astral_spirit:SetOwner(caster)
	caster.astral_spirit:AddNewModifier(caster.astral_spirit, self, "modifier_elder_titan_ancestral_spirit_lua", {})

	if not caster.astral_spirit:IsNull() then
		caster.astral_spirit:RemoveAbility("elder_titan_echo_stomp_spirit")
		caster.astral_spirit:RemoveAbility("elder_titan_return_spirit")
		caster.astral_spirit:RemoveAbility("elder_titan_natural_order_spirit")

		local echo_stomp_spirit = caster.astral_spirit:AddAbility("elder_titan_echo_stomp_spirit_lua")
		local echo_stomp = caster:FindAbilityByName("elder_titan_echo_stomp_lua")
		if (echo_stomp_spirit and not echo_stomp_spirit:IsNull()) and (echo_stomp and not echo_stomp:IsNull()) then
			echo_stomp_spirit:SetLevel(echo_stomp:GetLevel())
		end

		local return_spirit = caster.astral_spirit:AddAbility("elder_titan_return_spirit_lua")
		return_spirit:SetHidden(false)

		local move_spirit = caster:FindAbilityByName("elder_titan_move_spirit_lua")
		if move_spirit and not move_spirit:IsNull() then
			move_spirit:SetActivated(true)
		end

		caster.astral_spirit:SetBaseMoveSpeed(caster:GetIdealSpeed())
	end
end
