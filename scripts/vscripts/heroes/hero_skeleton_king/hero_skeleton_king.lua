
LinkLuaModifier('modifier_npc_dota_hero_skeleton_king_permanent_ability', "heroes/hero_skeleton_king/hero_skeleton_king", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_skeleton_king_permanent_ability_debuff', "heroes/hero_skeleton_king/hero_skeleton_king", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_skeleton_king_permanent_ability = class({})

function npc_dota_hero_skeleton_king_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_skeleton_king_permanent_ability'
end

function npc_dota_hero_skeleton_king_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

modifier_npc_dota_hero_skeleton_king_permanent_ability = {}

function modifier_npc_dota_hero_skeleton_king_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_skeleton_king_permanent_ability:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_REINCARNATION
    }
end

function modifier_npc_dota_hero_skeleton_king_permanent_ability:ReincarnateTime( params )
	if IsServer() then
			if self:GetAbility():IsFullyCastable() then
				if not self:GetParent():FindAbilityByName("skeleton_king_reincarnation"):IsCooldownReady() then
					self:Reincarnate()
					return self:GetAbility():GetSpecialValueFor( "respawnduration" )
				end
			end
			local aegis = self:GetParent():FindItemInInventory( "item_aegis" )
				if aegis ~= nil then
				self:GetParent():RemoveItem(aegis)
				return 5
			end
		return 0
	end
end

function modifier_npc_dota_hero_skeleton_king_permanent_ability:Reincarnate()
	self:GetAbility():UseResources( true, false, true )

	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),
		self:GetParent():GetAbsOrigin(),
		nil,
		self:GetAbility():GetSpecialValueFor( "slow_radius" ),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false
	)

	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_npc_dota_hero_skeleton_king_permanent_ability_debuff",
			{ duration = self:GetAbility():GetSpecialValueFor( "slow_duration" ) }
		)
	end

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self:GetAbility():GetSpecialValueFor( "reincarnate_time" ), 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( "Hero_SkeletonKing.Reincarnate", self:GetParent() )
end

modifier_npc_dota_hero_skeleton_king_permanent_ability_debuff = {}

function modifier_npc_dota_hero_skeleton_king_permanent_ability_debuff:IsHidden()
	return false
end

function modifier_npc_dota_hero_skeleton_king_permanent_ability_debuff:IsDebuff()
	return true
end

function modifier_npc_dota_hero_skeleton_king_permanent_ability_debuff:IsStunDebuff()
	return false
end

function modifier_npc_dota_hero_skeleton_king_permanent_ability_debuff:IsPurgable()
	return true
end

function modifier_npc_dota_hero_skeleton_king_permanent_ability_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_npc_dota_hero_skeleton_king_permanent_ability_debuff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor( "attackslow" )
end

function modifier_npc_dota_hero_skeleton_king_permanent_ability_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor( "movespeed" )
end

function modifier_npc_dota_hero_skeleton_king_permanent_ability_debuff:GetEffectName()
	return "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate_slow_debuff.vpcf"
end

function modifier_npc_dota_hero_skeleton_king_permanent_ability_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end