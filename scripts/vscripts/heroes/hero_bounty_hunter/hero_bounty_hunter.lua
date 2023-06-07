LinkLuaModifier( "modifier_npc_dota_hero_bounty_hunter_permanent_ability", "heroes/hero_bounty_hunter/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_bounty_hunter_permanent_ability = class({})

function npc_dota_hero_bounty_hunter_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_bounty_hunter_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_bounty_hunter_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_bounty_hunter_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_bounty_hunter_permanent_ability"
end

---------------------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_bounty_hunter_permanent_ability = class({})

function modifier_npc_dota_hero_bounty_hunter_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_bounty_hunter_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_bounty_hunter_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_bounty_hunter_permanent_ability:RemoveOnDeath()
	return false
end

function modifier_npc_dota_hero_bounty_hunter_permanent_ability:OnCreated( kv )
	self.percent = self:GetAbility():GetSpecialValueFor( "percent" )
end

function modifier_npc_dota_hero_bounty_hunter_permanent_ability:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_npc_dota_hero_bounty_hunter_permanent_ability:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		
	}
	return funcs
end

function modifier_npc_dota_hero_bounty_hunter_permanent_ability:OnAttackLanded(keys)
	if not (
		IsServer()
		and self:GetParent() == keys.attacker
		and keys.attacker:GetTeam() ~= keys.target:GetTeam()
		and not keys.attacker:IsRangedAttacker()
	) then return end
	if IsServer() and self:GetAbility() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() and self:GetAbility():IsCooldownReady() and not self:GetParent():PassivesDisabled() then
		if keys.target:IsRealHero() then
			self.damage =  keys.target:GetGold() * 0.15
			local damageTable = {
				victim			= keys.target,
				damage			= self.damage,
				damage_type		= DAMAGE_TYPE_PHYSICAL,
				damage_flags	= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				attacker		= keys.attacker,
				ability			= self:GetAbility()
			}
			ApplyDamage(damageTable)
			self:GetAbility():UseResources(false, false, true)
		elseif not keys.target:IsBuilding() then
			self.damage =  keys.attacker:GetGold() * 0.15
			local damageTable = {
				victim			= keys.target,
				damage			= self.damage,
				damage_type		= DAMAGE_TYPE_PHYSICAL,
				damage_flags	= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				attacker		= keys.attacker,
				ability			= self:GetAbility()
			}
			ApplyDamage(damageTable)
			self:GetAbility():UseResources(false, false, true)
		end
	end	
end