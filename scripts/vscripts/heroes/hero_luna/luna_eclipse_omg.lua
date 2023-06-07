LinkLuaModifier("modifier_luna_eclipse_omg", 		"heroes/hero_luna/luna_eclipse_omg.lua", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------

luna_eclipse_omg = class({})

--------------------------------------------------------------------------------

function luna_eclipse_omg:Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_luna/luna_eclipse_cast.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_luna/luna_eclipse_impact.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_luna/luna_eclipse_impact_notarget.vpcf", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_luna.vsndevts", context)
end

--------------------------------------------------------------------------------

function luna_eclipse_omg:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT + DOTA_ABILITY_BEHAVIOR_AOE
	end

	return self.BaseClass.GetBehavior(self)
end

--------------------------------------------------------------------------------

function luna_eclipse_omg:GetCastRange(...)
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("cast_range_tooltip_scepter")
	end

	return self.BaseClass.GetCastRange(self, ...)
end

--------------------------------------------------------------------------------

function luna_eclipse_omg:GetAOERadius()
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "radius" )
	end

	return 0
end

--------------------------------------------------------------------------------

function luna_eclipse_omg:GetCooldown(...)
	return self.BaseClass.GetCooldown(self, ...) - self:GetCaster():FindTalentValue("special_bonus_unique_luna_6")
end

--------------------------------------------------------------------------------

function luna_eclipse_omg:OnSpellStart()
    local caster = self:GetCaster()
    local position = self:GetCursorPosition()
    local cast_target = self:GetCursorTarget()
    local night_duration = self:GetSpecialValueFor("night_duration")
    local vision_radius = self:GetSpecialValueFor("radius")
    local beam_ability = caster:FindAbilityByName("luna_lucent_beam")
    local damage = caster:FindTalentValue("special_bonus_unique_luna_1")
    local target = caster

    if beam_ability then
        damage = damage + beam_ability:GetSpecialValueFor("beam_damage")
    else
        local beam_kv = GetAbilityKeyValuesByName("luna_lucent_beam")["AbilitySpecial"]
        damage = damage + splitstring(beam_kv["02"]["beam_damage"])[4]
    end

    if caster:HasScepter() then
        target = cast_target or nil
    end

    if target then
        target:AddNewModifier(caster, self, "modifier_luna_eclipse_omg", {duration = -1, damage = damage})
    else
        CreateModifierThinker(caster, self, "modifier_luna_eclipse_omg", {duration = -1, damage = damage}, position, caster:GetTeamNumber(), false)
    end

    GameRules:BeginTemporaryNight(night_duration)
end

--------------------------------------------------------------------------------

modifier_luna_eclipse_omg = modifier_luna_eclipse_omg or class({})

--------------------------------------------------------------------------------

function modifier_luna_eclipse_omg:IsPurgable() 		return false end
function modifier_luna_eclipse_omg:IsPurgeException() 	return false end
function modifier_luna_eclipse_omg:RemoveOnDeath()		return true end
function modifier_luna_eclipse_omg:GetAttributes()		return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

--------------------------------------------------------------------------------

function modifier_luna_eclipse_omg:OnCreated(kv)
    if IsServer() then
        local ability = self:GetAbility()
        local parent = self:GetParent()
        local caster = self:GetCaster()

        if not ability then return end

        local interval = ability:GetSpecialValueFor("beam_interval")
        self.max_beams = ability:GetSpecialValueFor("beams")
        self.max_hit_count = ability:GetSpecialValueFor("hit_count")
        self.radius = ability:GetSpecialValueFor("radius")
        self.is_thinker = parent:GetClassname() == "npc_dota_thinker"
        
        self.current_beams = 0
        self.hit_counter = {}

        self.damage_table = 
        {
            victim = nil,
            attacker = caster, 
            damage = kv.damage,
            damage_type = ability:GetAbilityDamageType(),
            ability = ability,
        }

        if caster:HasScepter() then
            interval = ability:GetSpecialValueFor("beam_interval_scepter")
            self.max_beams = ability:GetSpecialValueFor("beams_scepter")
            self.max_hit_count = ability:GetSpecialValueFor("hit_count_scepter")
        end

        if self.is_thinker then
            self.viewer_id = AddFOWViewer(caster:GetTeamNumber(), parent:GetAbsOrigin(), self.radius, 10, true)
        end

        local eclipse_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_eclipse_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
        ParticleManager:SetParticleControl(eclipse_cast_fx, 1, Vector(self.radius, 0, 0))
        self:AddParticle(eclipse_cast_fx, false, false, -1, false, false)

        EmitSoundOn("Hero_Luna.Eclipse.Cast", parent)

        self:StartIntervalThink(interval)
        self:OnIntervalThink()
    end
end


function modifier_luna_eclipse_omg:OnDestroy()
    if IsServer() then
        if self.viewer_id then
            RemoveFOWViewer(self:GetParent():GetTeamNumber(), self.viewer_id)
        end
    end
end

--------------------------------------------------------------------------------

function modifier_luna_eclipse_omg:OnIntervalThink()
    local parent = self:GetParent()
    local caster = self:GetCaster()
    local target = nil
    local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false)

    if not parent:IsAlive() or self.is_thinker and not caster:IsAlive() then
        self:Destroy()
        return
    end

	for _, enemy in pairs(enemies) do
        if not self.hit_counter[enemy:entindex()] or self.hit_counter[enemy:entindex()] < self.max_hit_count then
            self.hit_counter[enemy:entindex()] = self.hit_counter[enemy:entindex()] and (self.hit_counter[enemy:entindex()] + 1) or 1
            self.damage_table.victim = enemy
            ApplyDamage(self.damage_table)

            if caster:HasTalent("special_bonus_unique_luna_5") then
                enemy:AddNewModifier(caster, self:GetAbility(), "modifier_stunned", {duration = caster:FindTalentValue("special_bonus_unique_luna_5")})
            end

            target = enemy
            break
        end
    end

    if target then 
        local position = target:GetAbsOrigin()
        local beam_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_eclipse_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControl(beam_fx, 1, position)
        ParticleManager:SetParticleControlEnt(beam_fx, 5, target, PATTACH_POINT_FOLLOW, "attach_hitloc", position, true)
        ParticleManager:ReleaseParticleIndex(beam_fx)
        EmitSoundOn("Hero_Luna.Eclipse.Target", target)
    else
        local position = parent:GetAbsOrigin() + RandomVector(RandomInt(0, self.radius))
        local beam_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_eclipse_impact_notarget.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(beam_fx, 0, position)
        ParticleManager:SetParticleControl(beam_fx, 1, position)
        ParticleManager:SetParticleControl(beam_fx, 5, position)
        ParticleManager:ReleaseParticleIndex(beam_fx)
        EmitSoundOnLocationWithCaster(position, "Hero_Luna.Eclipse.NoTarget", self:GetCaster())
    end

    self.current_beams = self.current_beams + 1

    if self.current_beams >= self.max_beams then
        self:Destroy()
    end
end