tower_split_shot = class({})
LinkLuaModifier( "modifier_tower_split_shot", "abilities/tower_split_shot", LUA_MODIFIER_MOTION_NONE )

function tower_split_shot:GetIntrinsicModifierName()
	return "modifier_tower_split_shot"
end

-------------------------------------------------------------------------------------------------------------------------

modifier_tower_split_shot = class({})

function modifier_tower_split_shot:IsHidden()
	return true
end

function modifier_tower_split_shot:IsPurgable()
	return false
end

function modifier_tower_split_shot:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_tower_split_shot:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
	}
	return funcs
end

function modifier_tower_split_shot:OnAttack( params )
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end
	if params.no_attack_cooldown then return end
	if params.target:GetTeamNumber()==params.attacker:GetTeamNumber() then return end
	if self:GetParent():PassivesDisabled() then return end
	if not params.process_procs then return end
	if self.split_shot then return end

	self:SplitShotModifier( params.target )
end

function modifier_tower_split_shot:SplitShotModifier( target )
	local radius = self:GetParent():Script_GetAttackRange() + 100
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
	local count = 0
	for _,enemy in pairs(enemies) do
		if enemy ~= target then
			self.split_shot = true
			self:GetParent():PerformAttack(enemy, false, true, true, false, true, false, false)
			self.split_shot = false

			count = count + 1
			if count >= 2 then break end
		end
	end
end