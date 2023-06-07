LinkLuaModifier( "modifier_npc_dota_hero_huskar_permanent_ability", "heroes/hero_huskar/hero_huskar", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_huskar_permanent_ability = class({})

function npc_dota_hero_huskar_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_huskar_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_huskar_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_huskar_permanent_ability"
end
--------------------------------------------------------------------------------------------

modifier_npc_dota_hero_huskar_permanent_ability = class({})

function modifier_npc_dota_hero_huskar_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_huskar_permanent_ability:OnCreated()
if not IsServer() then return end
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
end

function modifier_npc_dota_hero_huskar_permanent_ability:OnRefresh()
	self:OnCreated()
end

function modifier_npc_dota_hero_huskar_permanent_ability:DeclareFunctions()		
	local decFuncs = 	{
						MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
						}		
	return decFuncs			
end

function modifier_npc_dota_hero_huskar_permanent_ability:GetModifierIncomingDamage_Percentage( params )
if params.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self:GetParent() == params.target and not params.attacker:IsOther() and params.attacker:GetName() ~= "npc_dota_unit_undying_zombie"
	and IsServer() and self:GetAbility() and self:GetParent():IsRealHero() and self:GetParent():IsAlive() and not self:GetParent():PassivesDisabled() then
		if params.damage >= self:GetParent():GetHealth() then
			if RandomInt(1,100) <= self.chance then
				self:GetCaster():EmitSound("Hero_Huskar.Inner_Fire.Cast")
					local pfxName = "particles/huskar/huskar.vpcf"
					local pfx = ParticleManager:CreateParticle( pfxName, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
					ParticleManager:SetParticleControl( pfx, 0, self:GetParent():GetAbsOrigin() )
					ParticleManager:SetParticleControl( pfx, 1, Vector(1.5,1.5,1.5) )
					ParticleManager:SetParticleControl( pfx, 3, self:GetParent():GetAbsOrigin() )
					ParticleManager:ReleaseParticleIndex(pfx)
				self:GetCaster():SetHealth(self:GetCaster():GetMaxHealth() * self:GetAbility():GetSpecialValueFor("hp")/100 )
				return -100
			end
		end
	end
end
