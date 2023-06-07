LinkLuaModifier( "modifier_npc_dota_hero_alchemist_permanent_ability", "heroes/hero_alchemist/hero_alchemist", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_alchemist_permanent_ability = class({})

function npc_dota_hero_alchemist_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_alchemist_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_alchemist_permanent_ability"
end

function npc_dota_hero_alchemist_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_alchemist_permanent_ability:IsRefreshable()
	return false 
end

---------------------------------------------------------------------------------------

modifier_npc_dota_hero_alchemist_permanent_ability = class({})

function modifier_npc_dota_hero_alchemist_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_alchemist_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_alchemist_permanent_ability:OnCreated( kv )
	self:StartIntervalThink(1)
end

function modifier_npc_dota_hero_alchemist_permanent_ability:OnIntervalThink()
if IsServer() and self:GetAbility() and self:GetCaster():IsRealHero() and self:GetParent():IsAlive() and not self:GetParent():PassivesDisabled() then
	if self:GetAbility():IsCooldownReady() then
		local front = self:GetCaster():GetForwardVector():Normalized()
		local target_pos = self:GetCaster():GetOrigin() + front * 200
		
		EmitSoundOn("SeasonalConsumable.TI9.Shovel.Dig", self:GetCaster())
		CreateRune(target_pos, DOTA_RUNE_BOUNTY)
		self:GetAbility():UseResources(false, false, true)
		end
	end
end