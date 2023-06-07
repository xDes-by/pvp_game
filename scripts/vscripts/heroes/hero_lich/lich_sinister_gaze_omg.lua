LinkLuaModifier("modifier_lich_sinister_gaze_omg",      "heroes/hero_lich/lich_sinister_gaze_omg", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------

lich_sinister_gaze_omg = class({})

--------------------------------------------------------------------------------

function lich_sinister_gaze_omg:Precache( context )
    PrecacheResource("particle", "particles/units/heroes/hero_lich/lich_gaze.vpcf", context)
    PrecacheResource("particle", "particles/status_fx/status_effect_lich_gaze.vpcf", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lich.vsndevts", context)
end

--------------------------------------------------------------------------------

function lich_sinister_gaze_omg:GetBehavior()
    if self:GetCaster():HasScepter() then
        return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL
    end

    return self.BaseClass.GetBehavior(self)
end

--------------------------------------------------------------------------------

function lich_sinister_gaze_omg:GetChannelTime()
	return self:GetSpecialValueFor("duration") + self:GetCaster():FindTalentValue("special_bonus_unique_lich_2")
end

--------------------------------------------------------------------------------

function lich_sinister_gaze_omg:GetCastRange(...)
    return self:GetSpecialValueFor("cast_range")
end

--------------------------------------------------------------------------------

function lich_sinister_gaze_omg:GetAOERadius()
    if self:GetCaster():HasScepter() then
        return self:GetSpecialValueFor("aoe_scepter")
    end

    return 0
end

--------------------------------------------------------------------------------

function lich_sinister_gaze_omg:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local duration = self:GetChannelTime()
    self.targets = {}    
    
    if caster:HasScepter() then
        local enemies = FindUnitsInRadius(
            caster:GetTeamNumber(),
            self:GetCursorPosition(),
            nil,
            self:GetSpecialValueFor("aoe_scepter"),
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            0,
            false
        )
        
        for _, enemy in pairs(enemies) do
            enemy:AddNewModifier(caster, self, "modifier_lich_sinister_gaze_omg", {duration = duration})
            table.insert(self.targets, enemy)
        end
    else
        if target:TriggerSpellAbsorb(self) then
            caster:Interrupt()
            return
        end

        target:AddNewModifier(caster, self, "modifier_lich_sinister_gaze_omg", {duration = duration})
        table.insert(self.targets, target)
    end

    EmitSoundOn("Hero_Lich.SinisterGaze.Cast", caster)
end

--------------------------------------------------------------------------------

function lich_sinister_gaze_omg:OnChannelFinish(interrupted)
    if not self or self:IsNull() then return end
        
    local caster = self:GetCaster()
    StopSoundOn("Hero_Lich.SinisterGaze.Cast", caster)

    for _, target in pairs(self.targets) do
        if target and not target:IsNull() and target:FindModifierByNameAndCaster("modifier_lich_sinister_gaze_omg", caster) then
            target:RemoveModifierByNameAndCaster("modifier_lich_sinister_gaze_omg", caster)
        end
    end
end

--------------------------------------------------------------------------------

modifier_lich_sinister_gaze_omg = class({})

--------------------------------------------------------------------------------

function modifier_lich_sinister_gaze_omg:IsPurgable()	return true end

--------------------------------------------------------------------------------

function modifier_lich_sinister_gaze_omg:OnCreated(kv)
    local ability = self:GetAbility()
    local parent = self:GetParent()
    local caster = self:GetCaster()

    if not ability or ability:IsNull() then return end

    local distance_pct = ability:GetSpecialValueFor("destination")
    local mana_drain = ability:GetSpecialValueFor("mana_drain")
    local duration = ability:GetChannelTime()
    local tick_rate = 0.1

    self.move_speed = (parent:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() * distance_pct / 100 / duration
    self.mana_drain_tick = mana_drain / duration * tick_rate

    if not IsServer() then return end
    local hand_attachment = (caster:ScriptLookupAttachment("attach_attack4") ~= 0) and "attach_attack4" or "attach_attack1"

    EmitSoundOn("Hero_Lich.SinisterGaze.Target", parent)
    local gaze_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_gaze.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
    ParticleManager:SetParticleControlEnt(gaze_fx, 1, parent, PATTACH_ABSORIGIN_FOLLOW, nil, parent:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(gaze_fx, 2, caster, PATTACH_POINT_FOLLOW, hand_attachment, caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(gaze_fx, 3, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(gaze_fx, 10, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), true)
    self:AddParticle(gaze_fx, false, false, -1, false, false)

    ExecuteOrderFromTable({
        UnitIndex = parent:entindex(),
        OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
        TargetIndex = caster:entindex(),
        Queue = false
    })

    self:StartIntervalThink(tick_rate)
    self:OnIntervalThink()
end

--------------------------------------------------------------------------------

function modifier_lich_sinister_gaze_omg:OnDestroy()
    if not IsServer() then return end
    local parent = self:GetParent()

    if not parent or parent:IsNull() then return end

    StopSoundOn("Hero_Lich.SinisterGaze.Target", parent)
    parent:Stop()
    GridNav:DestroyTreesAroundPoint(parent:GetAbsOrigin(), 200, false)
end

--------------------------------------------------------------------------------

function modifier_lich_sinister_gaze_omg:OnIntervalThink()
    local ability = self:GetAbility()
    local parent = self:GetParent()

    if not ability or ability:IsNull() then
        self:Destroy()
        return
    end

    local mana_drained = parent:GetMana() * self.mana_drain_tick / 100

    self:GetParent():ReduceMana(mana_drained)
    self:GetCaster():GiveMana(mana_drained)
end

--------------------------------------------------------------------------------

function modifier_lich_sinister_gaze_omg:CheckState()
    return {
        [MODIFIER_STATE_FEARED] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_INVISIBLE] = false,
    }
end

--------------------------------------------------------------------------------

function modifier_lich_sinister_gaze_omg:DeclareFunctions()
    return {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE}
end

--------------------------------------------------------------------------------

function modifier_lich_sinister_gaze_omg:GetModifierMoveSpeed_Absolute()
    return self.move_speed
end

--------------------------------------------------------------------------------

function modifier_lich_sinister_gaze_omg:GetStatusEffectName()
    return "particles/status_fx/status_effect_lich_gaze.vpcf"
end

--------------------------------------------------------------------------------

function modifier_lich_sinister_gaze_omg:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end