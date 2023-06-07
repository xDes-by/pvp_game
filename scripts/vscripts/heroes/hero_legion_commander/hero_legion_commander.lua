LinkLuaModifier( "modifier_npc_dota_hero_legion_commander_permanent_ability", "heroes/hero_legion_commander/hero_legion_commander", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_legion_commander_permanent_ability = class({})

function npc_dota_hero_legion_commander_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_legion_commander_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_legion_commander_permanent_ability"
end

function npc_dota_hero_legion_commander_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_legion_commander_permanent_ability:IsRefreshable()
	return false 
end

----------------------------------------------------------------------------

modifier_npc_dota_hero_legion_commander_permanent_ability = class({})

function modifier_npc_dota_hero_legion_commander_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_legion_commander_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_legion_commander_permanent_ability:RemoveOnDeath()
	return false
end

function modifier_npc_dota_hero_legion_commander_permanent_ability:OnCreated( kv )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self:StartIntervalThink(1)
end

function modifier_npc_dota_hero_legion_commander_permanent_ability:OnRefresh( kv )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "damage" )
end

function modifier_npc_dota_hero_legion_commander_permanent_ability:OnIntervalThink()
if IsServer() and self:GetAbility() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() then
	if self:GetAbility():IsCooldownReady() then
		local level = self:GetAbility():GetLevel()-1
		--self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(level))
		self:GetAbility():UseResources(false, false, true)
		self:GetCaster():SetModifierStackCount("modifier_npc_dota_hero_legion_commander_permanent_ability", self:GetCaster(), self:GetStackCount() + self.bonus_damage)
		end
	end
end

function modifier_npc_dota_hero_legion_commander_permanent_ability:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

function modifier_npc_dota_hero_legion_commander_permanent_ability:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()
end