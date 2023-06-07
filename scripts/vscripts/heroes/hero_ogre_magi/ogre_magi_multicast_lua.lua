ogre_magi_multicast_lua = {
	GetIntrinsicModifierName = function() return "modifier_multicast_lua" end,
}

LinkLuaModifier("modifier_multicast_lua", "heroes/hero_ogre_magi/ogre_magi_multicast_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_multicast_grow", "heroes/hero_ogre_magi/modifier_multicast_grow.lua", LUA_MODIFIER_MOTION_NONE)

---@class modifier_multicast_lua:CDOTA_Modifier_Lua
modifier_multicast_lua = {
	IsPurgable = function() return false end,
	GetEffectName = function() return "particles/arena/units/heroes/hero_ogre_magi/multicast_aghanims_buff.vpcf" end,
	GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
	DeclareFunctions = function() return { MODIFIER_EVENT_ON_ABILITY_EXECUTED } end,
}

function IsUltimateAbility(ability)
	return ability:GetAbilityType() == 1
end

if not IsServer() then return end

require("heroes/hero_ogre_magi/multicast_abilities")
local multicast_delay = 0.5

function modifier_multicast_lua:OnCreated()
	ListenToGameEvent("dota_ability_channel_finished", modifier_multicast_lua.OnAbilityEndChannel, self)
end

function modifier_multicast_lua:OnDestroy()
	StopListeningToAllGameEvents(self)
end

function modifier_multicast_lua:GetMulticastFactor(castedAbility)
	local ability = self:GetAbility()
	local caster = self:GetParent()

	if caster:PassivesDisabled() then return 1 end

	local multiplier = IsUltimateAbility(castedAbility) and 0 or 1
	if RollPercentage(ability:GetSpecialValueFor("multicast_4_times") * multiplier) then
		return 4
	elseif RollPercentage(ability:GetSpecialValueFor("multicast_3_times") * multiplier) then
		return 3
	elseif RollPercentage(ability:GetSpecialValueFor("multicast_2_times") * multiplier) then
		return 2
	end
	return 1
end

function modifier_multicast_lua:PlayMulticastFX(factor)
	if factor <= 1 then return end

	local caster = self:GetParent()
	local x = 1

	local fx = ParticleManager:CreateParticle('particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf', PATTACH_OVERHEAD_FOLLOW, caster)
	local delay = multicast_delay

	Timers:CreateTimer(delay, function()
		ParticleManager:DestroyParticle(fx, x ~= factor)
		if x < factor then
			x = x + 1
			fx = ParticleManager:CreateParticle('particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf', PATTACH_OVERHEAD_FOLLOW, caster)
			ParticleManager:SetParticleControl(fx, 1, Vector(x, 0, 0))
			caster:EmitSound('Hero_OgreMagi.Fireblast.x'.. x)
			return delay
		end
	end)
end

function modifier_multicast_lua:PlaySummonFX(summon, counter)
	local delay = multicast_delay
	local particle_name = "particles/units/heroes/hero_ursa/ursa_overpower_cast.vpcf"

	local modifier = summon:AddNewModifier(summon, nil, "modifier_multicast_grow", nil)
	if modifier and not modifier:IsNull() then
		modifier:SetStackCount(counter)
	end

	Timers:CreateTimer(delay, function()
		local pfx = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, summon)
		ParticleManager:ReleaseParticleIndex(pfx)

		counter = counter - 1

		if counter > 1 then
			return delay
		end
	end)
end

function modifier_multicast_lua:OnAbilityExecuted(keys)
	local parent = self:GetParent()
	if parent ~= keys.unit then return end
	local castedAbility = keys.ability

	local caster = self:GetParent()
	local target = keys.target or castedAbility:GetCursorPosition()
	local ability = self:GetAbility()
	local is_item = castedAbility:IsItem()

	if caster.multicast_dummy_owner then return end

	if not ability or ability:IsNull() then return end

	if is_item and (not keys.target or target:GetTeamNumber() == caster:GetTeamNumber()) then
		return
	end

	local multiplier = IsUltimateAbility(castedAbility) and 0 or 1
	local multicast = self:GetMulticastFactor(castedAbility)
	local delay = is_item and 0 or ability:GetSpecialValueFor("multicast_delay")

	if multicast > 1 then
		PerformMulticast(caster, castedAbility, multicast, delay, target)
	end
end

function GetAbilityMulticastType(ability)
	local name = ability:GetAbilityName()

	if MULTICAST_ABILITIES[name] then return MULTICAST_ABILITIES[name] end
	if ability:IsToggle() then return MULTICAST_TYPE_NONE end
	if ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_TOGGLE) then return MULTICAST_TYPE_NONE end
	if ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_PASSIVE) then return MULTICAST_TYPE_NONE end
	return ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) and MULTICAST_TYPE_DIFFERENT or MULTICAST_TYPE_SAME
end

function PerformMulticast(caster, ability_cast, multicast, multicast_delay, target)
	local multicast_type = GetAbilityMulticastType(ability_cast)

	caster.channel_interrupted = false

	if multicast_type ~= MULTICAST_TYPE_NONE and ability_cast:HasBehavior(DOTA_ABILITY_BEHAVIOR_CHANNELLED) then
		CreateMulticastDummies(caster)
	end

	if multicast_type ~= MULTICAST_TYPE_NONE then
		local prt = ParticleManager:CreateParticle('particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf', PATTACH_OVERHEAD_FOLLOW, caster)
		local multicast_flag_data = GetMulticastFlags(caster, ability_cast, multicast_type, target)
		local channelData = {}
		if multicast_type == MULTICAST_TYPE_INSTANT then
			Timers:NextTick(function()
				ParticleManager:SetParticleControl(prt, 1, Vector(multicast, 0, 0))
				ParticleManager:ReleaseParticleIndex(prt)
				local multicast_casted_data = {}
				for i = 2, multicast do
					CastMulticastedSpellInstantly(caster, ability_cast, target, multicast_flag_data, multicast_casted_data, 0, channelData)
				end
			end)
		else
			CastMulticastedSpell(caster, ability_cast, target, multicast-1, multicast_type, multicast_flag_data, { [target] = true }, multicast_delay, channelData, prt, 2)
		end
	end
end

function GetMulticastFlags(caster, ability, multicast_type, target)
	local rv = {}
	if multicast_type ~= MULTICAST_TYPE_SAME then
		local cast_range = ability:GetCastRange(caster:GetOrigin(), caster)
		local cast_range_bonus = caster:GetCastRangeBonus()
		rv.cast_range = cast_range + cast_range_bonus

		local abilityTarget = ability:GetAbilityTargetTeam()
		if abilityTarget == 0 then abilityTarget = DOTA_UNIT_TARGET_TEAM_ENEMY end

		--Is entity, not vector
		if target.GetTeam then
			-- Multicast select targets in same team of original cast target
			abilityTarget = target:GetTeam() == caster:GetTeam() and DOTA_UNIT_TARGET_TEAM_FRIENDLY or DOTA_UNIT_TARGET_TEAM_ENEMY
		end

		rv.abilityTarget = abilityTarget
		local abilityTargetType = ability:GetAbilityTargetType()
		if abilityTargetType == 0 then abilityTargetType = DOTA_UNIT_TARGET_ALL
		elseif abilityTargetType == 2 and ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_POINT) then abilityTargetType = 3
		elseif abilityTargetType == DOTA_UNIT_TARGET_CUSTOM then
			if target.IsHero and target:IsHero() then
				abilityTargetType = 1
			else
				abilityTargetType = 18 --basic
			end
		end
		
		rv.abilityTargetType = abilityTargetType
		rv.team = caster:GetTeam()
		rv.targetFlags = ability:GetAbilityTargetFlags()
	end
	return rv
end

function CastMulticastedSpellInstantly(caster, ability, target, multicast_flag_data, multicast_casted_data, delay, multicast_index)
	local is_item = ability:IsItem()
	local candidates = FindUnitsInRadius(multicast_flag_data.team, caster:GetOrigin(), nil, multicast_flag_data.cast_range, multicast_flag_data.abilityTarget, multicast_flag_data.abilityTargetType, multicast_flag_data.targetFlags, FIND_ANY_ORDER, false)
	local Tier1 = {} --heroes
	local Tier2 = {} --creeps and self
	local Tier3 = {} --already casted
	local Tier4 = {} --dead stuff
	for k, v in pairs(candidates) do
		if caster:CanEntityBeSeenByMyTeam(v) and (ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_POINT) or (not ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_POINT) and not v:IsUntargetable())) then
			if not is_item or not multicast_casted_data[v] then
				if multicast_casted_data[v] then
					Tier3[#Tier3 + 1] = v
				elseif not v:IsAlive() then
					Tier4[#Tier4 + 1] = v
				elseif v:IsHero() and v ~= caster then
					Tier1[#Tier1 + 1] = v
				else
					Tier2[#Tier2 + 1] = v
				end
			end
		end
	end
	local castTarget = Tier1[math.random(#Tier1)] or Tier2[math.random(#Tier2)] or Tier3[math.random(#Tier3)] or Tier4[math.random(#Tier4)] or target

	multicast_casted_data[castTarget] = true

	if not is_item or target ~= castTarget then
		CastAdditionalAbility(caster, ability, castTarget, delay, multicast_index)
	end
	
	return multicast_casted_data
end

function CastMulticastedSpell(caster, ability, target, multicasts, multicast_type, multicast_flag_data, multicast_casted_data, delay, channelData, prt, prtNumber)
	if multicasts >= 1 then
		Timers:CreateTimer(delay, function()
			ParticleManager:DestroyParticle(prt, true)
			ParticleManager:ReleaseParticleIndex(prt)

			if not ability:IsChanneling() and caster.channel_interrupted then return end

			prt = ParticleManager:CreateParticle('particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf', PATTACH_OVERHEAD_FOLLOW, caster)
			ParticleManager:SetParticleControl(prt, 1, Vector(prtNumber, 0, 0))
			if multicast_type == MULTICAST_TYPE_SAME then
				CastAdditionalAbility(caster, ability, target, delay * (prtNumber - 1), prtNumber)
			elseif multicast_type ~= MULTICAST_TYPE_SUMMON then
				multicast_casted_data = CastMulticastedSpellInstantly(caster, ability, target, multicast_flag_data, multicast_casted_data, delay * (prtNumber - 1), prtNumber)
			end
			caster:EmitSound('Hero_OgreMagi.Fireblast.x'.. multicasts)
			if multicasts >= 2 then
				CastMulticastedSpell(caster, ability, target, multicasts - 1, multicast_type, multicast_flag_data, multicast_casted_data, delay, channelData, prt, prtNumber + 1)
			end
		end)
	else
		ParticleManager:DestroyParticle(prt, false)
		ParticleManager:ReleaseParticleIndex(prt)
	end
end

function CastAdditionalAbility(caster, ability, target, delay, multicast_index)
	if not caster or caster:IsNull() or not caster.GetPlayerID then return end
	local skill = ability
	local unit = caster
	if (not skill) or (not ability) or skill:IsNull() or ability:IsNull() then return end

	if skill:HasBehavior(DOTA_ABILITY_BEHAVIOR_CHANNELLED) then
		CastChannelledAbility(caster, ability, target, multicast_index)
		return
	end

	if skill:HasBehavior(DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) then
		if target and type(target) == "table" then
			unit:SetCursorCastTarget(target)
		end
	end
	if skill:HasBehavior(DOTA_ABILITY_BEHAVIOR_POINT) then
		if target then
			if target.x and target.y and target.z then
				unit:SetCursorPosition(target)
			elseif target.GetOrigin then
				unit:SetCursorPosition(target:GetOrigin())
			end
		end
	end
	skill:OnSpellStart()
end

function CastChannelledAbility(caster, ability, target, multicast_index)
	local dummy = caster.multicast_dummies[multicast_index]

	if not ability:IsChanneling() and caster.channel_interrupted then return end

	local ability_name = ability:GetAbilityName()

	dummy:Interrupt()
	CopyDummy(dummy, caster)

	local dummy_ability = dummy:FindAbilityByName(ability_name) or dummy:FindItemInInventory(ability_name)
	dummy_ability:EndCooldown()

	Timers.CreateTimer(0.03, function()
		if not ability:IsChanneling() and caster.channel_interrupted then return end

		if ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_NO_TARGET) then
			dummy:CastAbilityNoTarget(dummy_ability, -1)
		else
			if target.x and target.y and target.z then
				target = target + RandomVector(RandomInt(50,200))
				dummy:CastAbilityOnPosition(target, dummy_ability, -1)
			else
				dummy:CastAbilityOnTarget(target, dummy_ability, -1)
			end
		end
	end)
end

function modifier_multicast_lua:OnAbilityEndChannel(event)
	local caster = EntIndexToHScript(event.caster_entindex)

	if caster.multicast_dummy_owner then
		caster:SetAbsOrigin(Vector(-16384, -16384, 0))
		return
	end

	if caster == self:GetParent() and event.interrupted == 1 then
		for _, dummy in pairs(caster.multicast_dummies or {}) do
			if IsValidEntity(dummy) then
				dummy:InterruptChannel()
				dummy:SetAbsOrigin(Vector(-16384, -16384, 0))
			end
		end
		caster.channel_interrupted = true
	end

end

function CreateMulticastDummies(caster)
	caster.multicast_dummies = caster.multicast_dummies or {}

	for i = 2,4 do
		if not IsValidEntity(caster.multicast_dummies[i]) then
			local origin = caster:GetAbsOrigin()
			dummy = CreateUnitByName(caster:GetUnitName(), Vector(-16384, -16384, 0), false, caster, caster, caster:GetTeam())
			dummy:AddNoDraw()
			
			dummy:AddNewModifier(dummy, nil, "modifier_hidden_caster_dummy", nil)
			dummy.multicast_dummy_owner = caster
			dummy:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
			dummy:MakeIllusion()
			caster.multicast_dummies[i] = dummy
		end
	end
end

function CopyDummy(dummy, caster)
	dummy:SetAbsOrigin(caster:GetAbsOrigin())
	dummy:SetForwardVector(caster:GetForwardVector())

	dummy:SetBaseAgility(caster:GetBaseAgility())
	dummy:SetBaseIntellect(caster:GetBaseIntellect())
	dummy:SetBaseStrength(caster:GetBaseStrength())

	for _,buff in pairs(caster:FindAllModifiers()) do
		local buff_name = buff:GetName()
		local buff_ability = buff:GetAbility()
		local dummy_buff = dummy:FindModifierByName(buff_name) or dummy:AddNewModifier(dummy, buff_ability, buff_name, {duration = buff:GetRemainingTime()})
		if dummy_buff then dummy_buff:SetStackCount(buff:GetStackCount()) end
	end

	for i = 0,6 do
		local item = caster:GetItemInSlot(i)
		local dummy_item = dummy:GetItemInSlot(i)

		if item then
			local item_name = item:GetAbilityName()

			if dummy_item then
				if dummy_item:GetAbilityName() ~= item_name then
					dummy:RemoveItem(dummy_item)
					dummy_item = dummy:AddItemByName(item_name)
				end
			else
				dummy_item = dummy:AddItemByName(item_name)
			end

			dummy_item:SetCurrentCharges(item:GetCurrentCharges())
			dummy_item:SetOverrideCastPoint(0)
			dummy_item.multicast_host_ability = i

			if item_name == "item_radiance" and not dummy_item:GetToggleState() then
				dummy_item:ToggleAbility()
			end

		elseif dummy_item then
			dummy:RemoveItem(dummy_item)
		end
	end

	for i = 0,DOTA_MAX_ABILITIES-1 do
		local ability = caster:GetAbilityByIndex(i)
		local dummy_ability = dummy:GetAbilityByIndex(i)

		if ability then
			local ability_name = ability:GetAbilityName()
			local ab = dummy:FindAbilityByName(ability_name) or dummy:AddAbility(ability_name)
			ab:SetLevel(ability:GetLevel())
			ab:SetOverrideCastPoint(0)
			ab.multicast_host_ability = ability
		end

		if dummy_ability then
			local ability_name = dummy_ability:GetAbilityName()
			if not caster:FindAbilityByName(ability_name) then
				dummy:RemoveAbility(ability_name)
			end
		end
	end
end
