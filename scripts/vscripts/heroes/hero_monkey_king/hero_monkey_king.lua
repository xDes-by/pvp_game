LinkLuaModifier( "modifier_npc_dota_hero_monkey_king_permanent_ability", "heroes/hero_monkey_king/hero_monkey_king", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_monkey_king_permanent_ability_effect", "heroes/hero_monkey_king/hero_monkey_king", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_monkey_king_permanent_ability = class({})

function npc_dota_hero_monkey_king_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_monkey_king_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_monkey_king_permanent_ability"
end

function npc_dota_hero_monkey_king_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_monkey_king_permanent_ability:IsRefreshable()
	return false 
end

----------------------------------------------------------------------------

modifier_npc_dota_hero_monkey_king_permanent_ability = class({})

function modifier_npc_dota_hero_monkey_king_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_monkey_king_permanent_ability:IsPurgable()
	return false
end


function modifier_npc_dota_hero_monkey_king_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
	return funcs
end

function modifier_npc_dota_hero_monkey_king_permanent_ability:OnAbilityFullyCast(params)
if IsServer() and self:GetAbility() and params.unit == self:GetParent() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() and not self:GetParent():PassivesDisabled() then
	if params.ability:IsItem() or params.ability:GetName() == "monkey_king_tree_dance" then return end
		EmitSoundOn( "Hero_MonkeyKing.FurArmy.End", self:GetCaster() )
		
		local duration = self:GetAbility():GetSpecialValueFor( "duration" )
		local outgoing = 100
		local incoming = 0
			
		local illusions = CreateIllusions(self:GetCaster(),self:GetCaster(),{outgoing_damage = outgoing,incoming_damage = incoming,duration = duration,},1,75,false,true)
		local illusion = illusions[1]
		illusion:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_npc_dota_hero_monkey_king_permanent_ability_effect", { duration = duration } )
	end
end

----------------------------------------------------------------------------------------------


local MODIFIER_PRIORITY_MONKAGIGA_EXTEME_HYPER_ULTRA_REINFORCED_V9 = 10001

modifier_npc_dota_hero_monkey_king_permanent_ability_effect = class({})

function modifier_npc_dota_hero_monkey_king_permanent_ability_effect:IsHidden()
	return true
end

function modifier_npc_dota_hero_monkey_king_permanent_ability_effect:IsDebuff()
	return false
end

function modifier_npc_dota_hero_monkey_king_permanent_ability_effect:IsPurgable()
	return false
end

function modifier_npc_dota_hero_monkey_king_permanent_ability_effect:OnRefresh( kv )
	
end

function modifier_npc_dota_hero_monkey_king_permanent_ability_effect:OnRemoved()
end

function modifier_npc_dota_hero_monkey_king_permanent_ability_effect:OnDestroy()
end

function modifier_npc_dota_hero_monkey_king_permanent_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}
	return funcs
end

function modifier_npc_dota_hero_monkey_king_permanent_ability_effect:GetModifierMoveSpeed_Absolute()
	return 0
end

function modifier_npc_dota_hero_monkey_king_permanent_ability_effect:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	}
	return state
end

function modifier_npc_dota_hero_monkey_king_permanent_ability_effect:GetStatusEffectName()
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

function modifier_npc_dota_hero_monkey_king_permanent_ability_effect:StatusEffectPriority()
	return MODIFIER_PRIORITY_MONKAGIGA_EXTEME_HYPER_ULTRA_REINFORCED_V9
end