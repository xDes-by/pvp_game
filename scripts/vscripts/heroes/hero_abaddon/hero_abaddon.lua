LinkLuaModifier( "modifier_npc_dota_hero_abaddon_permanent_ability", "heroes/hero_abaddon/hero_abaddon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_abaddon_permanent_ability_shield", "heroes/hero_abaddon/hero_abaddon", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_abaddon_permanent_ability = class({})

function npc_dota_hero_abaddon_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_abaddon_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_abaddon_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_abaddon_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_abaddon_permanent_ability"
end

--------------------------------------------------------------------------------

modifier_npc_dota_hero_abaddon_permanent_ability = class({})

function modifier_npc_dota_hero_abaddon_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_abaddon_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_abaddon_permanent_ability:OnCreated( kv )
end

function modifier_npc_dota_hero_abaddon_permanent_ability:OnRefresh( kv )
end

function modifier_npc_dota_hero_abaddon_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_npc_dota_hero_abaddon_permanent_ability:OnAttackLanded( params )
	if IsServer() then
		self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
		self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
		if self:GetAbility() and not self:GetCaster():PassivesDisabled() and params.attacker == self:GetCaster() then
			if RandomInt(1,100) < self.chance then
				self:GetParent():EmitSound("Hero_Abaddon.AphoticShield.Cast")
				self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_npc_dota_hero_abaddon_permanent_ability_shield",{ duration = self.duration })
			end
		end
	end
end

--------------------------------------------------------------------------------------

modifier_npc_dota_hero_abaddon_permanent_ability_shield = class({})

function modifier_npc_dota_hero_abaddon_permanent_ability_shield:IsHidden()
	return false
end

function modifier_npc_dota_hero_abaddon_permanent_ability_shield:IsPurgable()
	return true
end

function modifier_npc_dota_hero_abaddon_permanent_ability_shield:IsDebuff()
	return false
end

function modifier_npc_dota_hero_abaddon_permanent_ability_shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}
end

function modifier_npc_dota_hero_abaddon_permanent_ability_shield:OnCreated()
	if IsServer() then
		local shield_size = self:GetParent():GetModelRadius() * 0.7
		local ability_level = self:GetAbility():GetLevel()
		local target_origin = self:GetParent():GetAbsOrigin()
		
		self.shield_remaining = self:GetAbility():GetSpecialValueFor( "shield_block" )
		self.target_current_health = self:GetParent():GetHealth()

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		local common_vector = Vector(shield_size,0,shield_size)
		ParticleManager:SetParticleControl(particle, 1, common_vector)
		ParticleManager:SetParticleControl(particle, 2, common_vector)
		ParticleManager:SetParticleControl(particle, 4, common_vector)
		ParticleManager:SetParticleControl(particle, 5, Vector(shield_size,0,0))


		ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", target_origin, true)
		self:AddParticle(particle, false, false, -1, false, false)
	end
end

function modifier_npc_dota_hero_abaddon_permanent_ability_shield:OnDestroy()
end


function modifier_npc_dota_hero_abaddon_permanent_ability_shield:GetModifierTotal_ConstantBlock(kv)
	if IsServer() then
		local original_shield_amount = self:GetAbility():GetSpecialValueFor( "shield_block" )
		local shield_hit_particle = "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_hit.vpcf"
		if kv.damage > 0  then --and bit.band(kv.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS
			
			self.shield_remaining = self.shield_remaining - kv.damage
		
		if kv.damage < original_shield_amount then

				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, self:GetParent(), kv.damage, nil)
				return kv.damage
			else
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, self:GetParent(), original_shield_amount, nil)
				self:Destroy()
				return original_shield_amount
			end
		end
	end
end

function modifier_npc_dota_hero_abaddon_permanent_ability_shield:OnDestroy()
	if IsServer() then
		local radius = 300
		self:GetParent():EmitSound("Hero_Abaddon.AphoticShield.Destroy")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)

		local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local damage = self:GetAbility():GetSpecialValueFor( "shield_block" )
		local damage_type = DAMAGE_TYPE_MAGICAL

		for _, unit in pairs(units) do
			if not unit:IsMagicImmune() then
				ApplyDamage({ victim = unit, attacker = self:GetParent(), damage = damage, damage_type = damage_type })
			end
		end
	end
end