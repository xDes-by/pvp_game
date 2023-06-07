npc_dota_hero_leshrac_permanent_ability = class({})

LinkLuaModifier( "modifier_npc_dota_hero_leshrac_permanent_ability", "heroes/hero_leshrac/hero_leshrac", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_leshrac_permanent_ability_effect", "heroes/hero_leshrac/hero_leshrac", LUA_MODIFIER_MOTION_NONE )
function npc_dota_hero_leshrac_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_leshrac_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_leshrac_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_leshrac_permanent_ability:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_leshrac_permanent_ability"
end



modifier_npc_dota_hero_leshrac_permanent_ability = class({})

function modifier_npc_dota_hero_leshrac_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_leshrac_permanent_ability:IsPurgable()
	return false
end


function modifier_npc_dota_hero_leshrac_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
	return funcs
end

function modifier_npc_dota_hero_leshrac_permanent_ability:OnAbilityFullyCast(params)
if IsServer() and self:GetAbility() and params.unit == self:GetParent() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() and not self:GetParent():PassivesDisabled() then
	if params.ability:IsItem() then return end
		if RandomInt(1,100) <= self:GetAbility():GetSpecialValueFor("chance") then
			EmitSoundOn( "Hero_ObsidianDestroyer.Equilibrium.Cast", self:GetCaster() )		
			self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_npc_dota_hero_leshrac_permanent_ability_effect", { duration = self:GetAbility():GetSpecialValueFor("duration") } )
		end		
	end
end

----------------------------------------------------------------------------------------------

modifier_npc_dota_hero_leshrac_permanent_ability_effect = class({})

function modifier_npc_dota_hero_leshrac_permanent_ability_effect:IsHidden()
	return false
end

function modifier_npc_dota_hero_leshrac_permanent_ability_effect:IsDebuff()
	return false
end

function modifier_npc_dota_hero_leshrac_permanent_ability_effect:IsPurgable()
	return false
end

function modifier_npc_dota_hero_leshrac_permanent_ability_effect:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_npc_dota_hero_leshrac_permanent_ability_effect:OnTakeDamage(keys)
	if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() then	
		if keys.damage_category == 0 and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
	
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			
			if keys.attacker:GetHealth() <= (keys.original_damage * (self:GetAbility():GetSpecialValueFor("lifestal") / 100)) and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
				keys.attacker:ForceKill(true)
			else
				keys.attacker:Heal(keys.original_damage * (self:GetAbility():GetSpecialValueFor("lifestal") / 100), self)
			end
		end
	end
end