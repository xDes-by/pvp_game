npc_dota_hero_ursa_permanent_ability = class({})

LinkLuaModifier( "modifier_npc_dota_hero_ursa_permanent_ability", "heroes/hero_ursa/hero_ursa", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_ursa_permanent_ability_buff", "heroes/hero_ursa/hero_ursa", LUA_MODIFIER_MOTION_NONE )

function npc_dota_hero_ursa_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_ursa_permanent_ability:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ursa.vsndevts", context )
	PrecacheResource( "particle", "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf", context )
end

function npc_dota_hero_ursa_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_ursa_permanent_ability"
end

modifier_npc_dota_hero_ursa_permanent_ability = class({})

function modifier_npc_dota_hero_ursa_permanent_ability:IsHidden()
	if self:GetStackCount() > 0 then
		return false
	end
	return true
end

function modifier_npc_dota_hero_ursa_permanent_ability:GetTexture()
	return ""
end

function modifier_npc_dota_hero_ursa_permanent_ability:RemoveOnDeath()
	return false
end

function modifier_npc_dota_hero_ursa_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_ursa_permanent_ability:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_npc_dota_hero_ursa_permanent_ability:OnAttackLanded(params)
	local attacker = params.attacker
	local target =  params.target
	if attacker == self:GetParent() and attacker:IsRealHero() and not self:GetParent():PassivesDisabled() then
	self:IncrementStackCount()
		local buffhits = self:GetAbility():GetSpecialValueFor("hits")
		if self:GetStackCount() == buffhits then 
			attacker:AddNewModifier(attacker, self:GetAbility(), "modifier_npc_dota_hero_ursa_permanent_ability_buff", {duration = 2})
			local sound_cast = "Hero_Ursa.Enrage"
			EmitSoundOn( sound_cast, self:GetCaster() )
			self:SetStackCount(0)
		end
	end
end

modifier_npc_dota_hero_ursa_permanent_ability_buff = class({})

function modifier_npc_dota_hero_ursa_permanent_ability_buff:IsHidden()
	return false
end

function modifier_npc_dota_hero_ursa_permanent_ability_buff:IsDebuff()
	return false
end

function modifier_npc_dota_hero_ursa_permanent_ability_buff:IsStunDebuff()
	return false
end

function modifier_npc_dota_hero_ursa_permanent_ability_buff:IsPurgable()
	return false
end

function modifier_npc_dota_hero_ursa_permanent_ability_buff:RemoveOnDeath()
	return false
end

function modifier_npc_dota_hero_ursa_permanent_ability_buff:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_npc_dota_hero_ursa_permanent_ability_buff:OnAttackLanded(keys)	
	local damage = self:GetAbility():GetSpecialValueFor("splash") * keys.damage * 0.01
	local particle_cast = 'particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf'
	if keys.attacker == self:GetParent() and keys.attacker:IsRealHero() then
		DoCleaveAttack(self:GetParent(),keys.target,self:GetAbility(),damage,150,360,650,particle_cast)
	end
end

function modifier_npc_dota_hero_ursa_permanent_ability_buff:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
end

function modifier_npc_dota_hero_ursa_permanent_ability_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_npc_dota_hero_ursa_permanent_ability_buff:GetModifierPreAttack_BonusDamage( params )
	return self:GetAbility():GetSpecialValueFor("damage")
end

function modifier_npc_dota_hero_ursa_permanent_ability_buff:GetModifierModelScale( params )
	return 30
end