LinkLuaModifier( "modifier_npc_dota_hero_spirit_breaker_permanent_ability", "heroes/hero_spirit_breaker/hero_spirit_breaker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_spirit_breaker_permanent_ability_effect", "heroes/hero_spirit_breaker/hero_spirit_breaker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_knockback_lua", "heroes/generic/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dummy", "modifiers/modifier_dummy", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_spirit_breaker_permanent_ability = class({})

function npc_dota_hero_spirit_breaker_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_spirit_breaker_permanent_ability:IsStealable()
	return false
end

function npc_dota_hero_spirit_breaker_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_spirit_breaker_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_spirit_breaker_permanent_ability"
end

--------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_spirit_breaker_permanent_ability = class({})

function modifier_npc_dota_hero_spirit_breaker_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_spirit_breaker_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_spirit_breaker_permanent_ability:OnCreated( kv )
	self:StartIntervalThink(1)
end

function modifier_npc_dota_hero_spirit_breaker_permanent_ability:OnIntervalThink()
if IsServer() and self:GetAbility() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() then
	if self:GetAbility():IsCooldownReady() then
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local carges = self:GetAbility():GetSpecialValueFor("carges")
		local caster = self:GetCaster()
		local caster_pos = self:GetCaster():GetAbsOrigin()
		local line_pos = caster_pos + self:GetCaster():GetForwardVector() * radius
		local rotation_rate = 360 / carges
		self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_npc_dota_hero_spirit_breaker_permanent_ability_effect",{duration = 0.5 * carges} )
		points = {}
		caster:EmitSound("Hero_Spirit_Breaker.RagingBull")
		Timers:CreateTimer(4, function()
		caster:EmitSound("Hero_Spirit_Breaker.RagingBull")
		end)
				
		for i = 1, carges do
			local rand = RandomInt(0,50)
			line_pos = RotatePosition(caster_pos, QAngle(0, rotation_rate, rand), line_pos)
			local dummy = CreateUnitByName("npc_dummy_unit", line_pos, false, caster, caster, caster:GetTeamNumber())
			dummy:AddNewModifier(caster,self,"modifier_dummy",{} )
			dummy:AddNewModifier(caster,self,"modifier_kill",{duration = 1} )
			local position = dummy:GetAbsOrigin()
			table.insert(points, position)
		end	
		
		Timers:CreateTimer(0.1, function()
			self:Move(caster)
		end)	
		self:GetAbility():UseResources(false, false, true)
		end
	end
end


function modifier_npc_dota_hero_spirit_breaker_permanent_ability:Move(caster)	
	move_point = points[RandomInt(1,#points)]
		if move_point ~= nil then
			Timers:CreateTimer(0.1, function()
				if not caster:HasModifier("modifier_npc_dota_hero_spirit_breaker_permanent_ability_effect") then return nil end
				local flDist = (caster:GetAbsOrigin() - move_point):Length2D()
					if flDist > 150 then 
						caster:MoveToPosition(move_point)
					else
						for i, point in ipairs( points ) do
							if move_point == point then
								table.remove( points, i )
								self:Move(caster)
								return nil
							end
						end
					end
				return 0.1
			end)
		end
	if #points == 0 then
		caster:RemoveModifierByName("modifier_npc_dota_hero_spirit_breaker_permanent_ability_effect")
	end
end

-----------------------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_spirit_breaker_permanent_ability_effect = class({})

function modifier_npc_dota_hero_spirit_breaker_permanent_ability_effect:IsHidden()	
	return false
end

function modifier_npc_dota_hero_spirit_breaker_permanent_ability_effect:IsPurgable()
	return false
end

function modifier_npc_dota_hero_spirit_breaker_permanent_ability_effect:CheckState()
	return {
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	}
end

function modifier_npc_dota_hero_spirit_breaker_permanent_ability_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end

function modifier_npc_dota_hero_spirit_breaker_permanent_ability_effect:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_npc_dota_hero_spirit_breaker_permanent_ability_effect:GetDisableAutoAttack()
	return 1
end

function modifier_npc_dota_hero_spirit_breaker_permanent_ability_effect:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_npc_dota_hero_spirit_breaker_permanent_ability_effect:GetOverrideAnimation()
	return ACT_DOTA_TAUNT
end

function modifier_npc_dota_hero_spirit_breaker_permanent_ability_effect:GetEffectName()
	return "particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge.vpcf"
end

function modifier_npc_dota_hero_spirit_breaker_permanent_ability_effect:GetStatusEffectName()
	return "particles/status_fx/status_effect_charge_of_darkness.vpcf"
end

function modifier_npc_dota_hero_spirit_breaker_permanent_ability_effect:OnCreated()
if not IsServer() then return end
	local damage = self:GetAbility():GetSpecialValueFor("damage") * 0.01
	self.damage = self:GetCaster():GetAverageTrueAttackDamage(nil) * damage
	self:StartIntervalThink(0.1)	
end

function modifier_npc_dota_hero_spirit_breaker_permanent_ability_effect:OnIntervalThink()
	self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), 200, true )
	local damageTable = {
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self:GetAbility(),
		}
		
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 195, DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy and not enemy:HasModifier("modifier_knockback") then
					enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_knockback", {
						center_x			= self:GetParent():GetAbsOrigin()[1] + 1,
						center_y			= self:GetParent():GetAbsOrigin()[2] + 1,
						center_z			= self:GetParent():GetAbsOrigin()[3],
						duration			= 0.5 * (1 - enemy:GetStatusResistance()),
						knockback_duration	= 0.1 * (1 - enemy:GetStatusResistance()),
						knockback_distance	= 50,
						knockback_height	= 0,
						should_stun			= 0
					})
				
					damageTable.victim = enemy
					ApplyDamage( damageTable )
					enemy:AddNewModifier(self:GetParent(),self,"modifier_stunned",{ duration = self.stun_duration * (1 - enemy:GetStatusResistance()) }	)
					
	
					enemy:EmitSound("Hero_Spirit_Breaker.Charge.Impact")
				end
			end
		end
end