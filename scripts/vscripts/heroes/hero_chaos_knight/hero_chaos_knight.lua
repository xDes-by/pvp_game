LinkLuaModifier( "modifier_npc_dota_hero_chaos_knight_permanent_ability", "heroes/hero_chaos_knight/hero_chaos_knight", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_chaos_knight_permanent_ability = class({})

function npc_dota_hero_chaos_knight_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_chaos_knight_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_chaos_knight_permanent_ability"
end

function npc_dota_hero_chaos_knight_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_chaos_knight_permanent_ability:IsRefreshable()
	return false 
end

----------------------------------------------------------------------------

modifier_npc_dota_hero_chaos_knight_permanent_ability = class({})

function modifier_npc_dota_hero_chaos_knight_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_chaos_knight_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_chaos_knight_permanent_ability:OnCreated( kv )
	self:StartIntervalThink(1)
end

function modifier_npc_dota_hero_chaos_knight_permanent_ability:OnIntervalThink()
if IsServer() and self:GetAbility() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() and not self:GetParent():PassivesDisabled() then
	if self:GetAbility():IsCooldownReady() then
		local sound_cast = "Hero_ChaosKnight.Phantasm"
		EmitSoundOn( sound_cast, self:GetCaster() )
		
		local duration = self:GetAbility():GetSpecialValueFor( "illusion_duration" )
		local outgoing = self:GetAbility():GetSpecialValueFor( "illusion_outgoing_tooltip" )
		local incoming = self:GetAbility():GetSpecialValueFor( "illusion_incoming_damage" )
			
		local illusions = CreateIllusions(self:GetCaster(),self:GetCaster(),{outgoing_damage = outgoing,incoming_damage = incoming,duration = duration,},1,75,false,true)

		local level = self:GetAbility():GetLevel()-1
		--self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(level))
		self:GetAbility():UseResources(false, false, true)
		end
	end
end