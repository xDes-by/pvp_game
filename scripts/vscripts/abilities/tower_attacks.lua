LinkLuaModifier( "modifier_tower_attacks", "abilities/tower_attacks", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_tower_attacks_effect", "abilities/tower_attacks", LUA_MODIFIER_MOTION_HORIZONTAL )

tower_attacks = class({})

function tower_attacks:GetIntrinsicModifierName()
	return "modifier_tower_attacks"
end

-----------------------------------------------------------------------------------------------------

modifier_tower_attacks = class({})

function modifier_tower_attacks:IsHidden( kv )
	return true
end

function modifier_tower_attacks:IsDebuff( kv )
	return false
end

function modifier_tower_attacks:IsPurgable( kv )
	return false
end

function modifier_tower_attacks:RemoveOnDeath( kv )
	return false
end

function modifier_tower_attacks:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}
	return funcs
end

function modifier_tower_attacks:GetModifierProcAttack_BonusDamage_Physical( params )
	if IsServer() then
		local target = params.target if target == nil then target = params.unit end
		if target:GetTeamNumber() == self:GetParent():GetTeamNumber() then return 0 end
		local stack = 0
		local modifier = target:FindModifierByName("modifier_tower_attacks_effect")

		if modifier == nil then
			target:AddNewModifier( self:GetAbility():GetCaster(), self:GetAbility(), "modifier_tower_attacks_effect", { duration = 6})
			stack = 1
		else
			modifier:IncrementStackCount()
			modifier:ForceRefresh()
			stack = modifier:GetStackCount()
		end	
		return stack * (target:GetMaxHealth()/100 * 3)
	end
end

--------------------------------------------------------------------------------

modifier_tower_attacks_effect = class({})

function modifier_tower_attacks_effect:IsHidden()
	return false
end

function modifier_tower_attacks_effect:IsDebuff()
	return true
end

function modifier_tower_attacks_effect:IsPurgable()
	return false
end

function modifier_tower_attacks_effect:GetAttributes()	
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_tower_attacks_effect:OnCreated( kv )
	self:SetStackCount(1)
end