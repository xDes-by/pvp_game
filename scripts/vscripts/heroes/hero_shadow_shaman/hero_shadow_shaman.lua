LinkLuaModifier('modifier_npc_dota_hero_shadow_shaman_permanent_ability', "heroes/hero_shadow_shaman/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_hex_ampl_spirit", "heroes/hero_shadow_shaman/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_shadow_shaman_permanent_ability = class({})

function npc_dota_hero_shadow_shaman_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_shadow_shaman_permanent_ability'
end

function npc_dota_hero_shadow_shaman_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_shadow_shaman_permanent_ability:IsRefreshable()
	return false 
end
---------------------------------------------------------------------------------------

modifier_npc_dota_hero_shadow_shaman_permanent_ability = class({})

function modifier_npc_dota_hero_shadow_shaman_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_shadow_shaman_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_shadow_shaman_permanent_ability:OnCreated( kv )
	self:StartIntervalThink(1)
end

function modifier_npc_dota_hero_shadow_shaman_permanent_ability:OnIntervalThink()
if IsServer() and self:GetAbility() and self:GetCaster():IsRealHero() and self:GetParent():IsAlive() and not self:GetParent():PassivesDisabled() then
	if self:GetAbility():IsCooldownReady() then
		local spawn_hex = CreateUnitByName( "npc_shaman_hex", self:GetCaster():GetAbsOrigin() + RandomVector( RandomInt( 150, 150 )), true, nil, nil, self:GetCaster():GetTeamNumber() )
		spawn_hex:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
		spawn_hex:SetOwner(self:GetCaster())
		spawn_hex:AddNewModifier(spawn_hex, self:GetAbility(), "modifier_hex_ampl_spirit",  { }) 	
		spawn_hex:AddNewModifier(spawn_hex, nil, "modifier_kill",  {duration = self:GetAbility():GetSpecialValueFor("duration")}) 	
		self:GetCaster():EmitSound("Hero_ShadowShaman.Hex.Target")		
		self:GetAbility():UseResources(false, false, true)
		end
	end
end

--------------------------------------------------------------------------------------

modifier_hex_ampl_spirit = class({})

function modifier_hex_ampl_spirit:IsHidden()
	return false
end

function modifier_hex_ampl_spirit:IsPurgable()
	return false
end

function modifier_hex_ampl_spirit:OnCreated()
if IsServer() then
    local player = self:GetCaster():GetOwner()
	spell_amp_hex = player:GetSpellAmplification(false) * 100
	end
end

function modifier_hex_ampl_spirit:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
    }
    return state
end

function modifier_hex_ampl_spirit:DeclareFunctions()
	return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
end

function modifier_hex_ampl_spirit:GetModifierSpellAmplify_Percentage()
	return spell_amp_hex
end

function modifier_hex_ampl_spirit:OnCreated()
    self:StartIntervalThink(0.03)
end

function modifier_hex_ampl_spirit:OnIntervalThink()
	if IsServer() then
		if not self:GetCaster():IsAlive() then
			self:Destroy()
        end
		
		self.damage = self:GetAbility():GetSpecialValueFor("damage")
        
        local damage_radius = self:GetAbility():GetSpecialValueFor("boom_radius")

        local Enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
        if #Enemies > 0 then
            EmitSoundOn("Hero_Techies.LandMine.Detonate", self:GetCaster():GetOwner())

            local particle_explosion = "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf"
            local particle_explosion_fx = ParticleManager:CreateParticle(particle_explosion, PATTACH_WORLDORIGIN, self:GetCaster())
            ParticleManager:SetParticleControl(particle_explosion_fx, 0, self:GetCaster():GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_explosion_fx, 1, self:GetCaster():GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_explosion_fx, 2, Vector(damage_radius, 1, 1))
            ParticleManager:ReleaseParticleIndex(particle_explosion_fx)

            local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

            for _,enemy in pairs(enemies) do
                local distance = (self:GetCaster():GetAbsOrigin() - enemy:GetAbsOrigin()):Length2D()
                local damageTable = {victim = enemy,
                                     attacker = self:GetCaster(), 
                                     damage = self.damage,
                                     damage_type = DAMAGE_TYPE_MAGICAL,
                }
				enemy:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_stunned",{ duration = self:GetAbility():GetSpecialValueFor("stun") * (1 - enemy:GetStatusResistance())})
                ApplyDamage(damageTable)
            end
            self:GetCaster():ForceKill(false)
            self:Destroy()
        end
    end    
end



