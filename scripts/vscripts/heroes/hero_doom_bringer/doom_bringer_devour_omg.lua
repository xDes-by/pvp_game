local CONST_MAX_MODIFIERS = 2
local CONST_ALLOWED_ABILITIES = {
    ["kobold_taskmaster_speed_aura"]            = "modifier_kobold_taskmaster_speed_aura_omg",
    ["mudgolem_cloak_aura"]                     = "modifier_mudgolem_cloak_aura_omg",
    ["centaur_khan_endurance_aura"]             = "modifier_centaur_khan_endurance_aura_omg",
    ["alpha_wolf_command_aura"]                 = "modifier_alpha_wolf_command_aura_omg",
    ["alpha_wolf_critical_strike"]              = "modifier_alpha_wolf_critical_strike_omg",
    ["enraged_wildkin_toughness_aura"]          = "modifier_enraged_wildkin_toughness_aura_omg",
    ["satyr_hellcaller_unholy_aura"]            = "modifier_satyr_hellcaller_unholy_aura_omg",
    ["gnoll_assassin_envenomed_weapon"]         = "modifier_gnoll_assassin_envenomed_weapon_omg",
    ["ghost_frost_attack"]                      = "modifier_ghost_frost_attack_omg",
    ["forest_troll_high_priest_mana_aura"]      = "modifier_forest_troll_high_priest_mana_aura_omg",
    ["kobold_tunneler_prospecting"]             = "modifier_kobold_tunneler_prospecting_aura_omg",
    ["kobold_disarm"]                           = "modifier_kobold_disarm_omg",
    ["berserker_troll_break"]                   = "modifier_berserker_troll_break_omg",
    ["forest_troll_high_priest_heal_amp_aura"]  = "modifier_forest_troll_high_priest_heal_amp_aura_omg",
    ["furbolg_enrage_attack_speed"]             = "modifier_furbolg_enrage_attack_speed_omg",
    ["furbolg_enrage_damage"]                   = "modifier_furbolg_enrage_damage_omg",
    -- Ancients
    ["black_drake_magic_amplification_aura"]    = "modifier_black_drake_magic_amplification_aura_omg",
    ["black_dragon_splash_attack"]              = "modifier_black_dragon_splash_attack_omg",
    ["black_dragon_dragonhide_aura"]            = "modifier_black_dragon_dragonhide_aura_omg",
    ["ancient_rock_golem_weakening_aura"]       = "modifier_ancient_rock_golem_weakening_aura_omg",
    ["granite_golem_hp_aura"]                   = "modifier_granite_golem_hp_aura_omg",
    ["big_thunder_lizard_wardrums_aura"]        = "modifier_big_thunder_lizard_wardrums_aura_omg",
    ["frostbitten_golem_time_warp_aura"]        = "modifier_frostbitten_golem_time_warp_aura_omg",
}

--------------------------------------------------------------------------------

LinkLuaModifier("modifier_doom_bringer_devour_omg",                 "heroes/hero_doom_bringer/doom_bringer_devour_omg", LUA_MODIFIER_MOTION_NONE)
require("heroes/hero_doom_bringer/devour_modifiers/link_modifiers")

--------------------------------------------------------------------------------

doom_bringer_devour_omg = class({})

--------------------------------------------------------------------------------

function doom_bringer_devour_omg:Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_doombringer.vsndevts", context)
end

--------------------------------------------------------------------------------

function doom_bringer_devour_omg:Spawn()
    if not IsServer() then return end
    if not self.active_modifiers then self.active_modifiers = {} end
end

--------------------------------------------------------------------------------

function doom_bringer_devour_omg:OnUpgrade()
    if self:GetLevel() == 1 then
    	self:ToggleAutoCast()
    end    
end

--------------------------------------------------------------------------------

function doom_bringer_devour_omg:CastFilterResultTarget(target)
    local caster = self:GetCaster()
    local max_level = self:GetSpecialValueFor("creep_level")
    local ancient_flag = not caster:HasTalent("special_bonus_unique_doom_2") and DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS or 0

    local result = UnitFilter(
		target,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC,
		ancient_flag + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,
		caster:GetTeamNumber()
	)

	if result ~= UF_SUCCESS then
		return result
	end

    if target:GetUnitName() == "npc_dota_roshan" or target:GetLevel() > max_level then
        return UF_FAIL_CUSTOM
    end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function doom_bringer_devour_omg:GetCustomCastErrorTarget(target)
    if target:GetUnitName() == "npc_dota_roshan" then
        return "#dota_hud_error_cant_cast_on_roshan"
    else
        return "#dota_hud_error_cant_cast_creep_level"
    end
end

--------------------------------------------------------------------------------

function doom_bringer_devour_omg:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local duration = self:GetEffectiveCooldown(self:GetLevel())


    target:Kill(self, caster)
    caster:AddNewModifier(caster, self, "modifier_doom_bringer_devour_omg", {duration = duration})

    if self:GetAutoCastState() then
        self:CheckPassiveAbilities(target)
    end

    EmitSoundOn("Hero_DoomBringer.Devour", target)
    EmitSoundOn("Hero_DoomBringer.DevourCast", caster)
    
    local devour_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControlEnt(devour_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(devour_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(devour_fx)
end

--------------------------------------------------------------------------------

function doom_bringer_devour_omg:CheckPassiveAbilities(target)
    local cleared = false
    local granted_count = 0

    for id = 0, DOTA_MAX_ABILITIES - 1, 1 do
        local ability = target:GetAbilityByIndex(id)
        if ability and CONST_ALLOWED_ABILITIES[ability:GetName()] then
            if not cleared then
                cleared = true
                self:ClearModifiers()
            end

            self:GrantPassive(CONST_ALLOWED_ABILITIES[ability:GetName()])

            granted_count = granted_count + 1
            if granted_count >= CONST_MAX_MODIFIERS then
                break
            end
        end
    end
end

--------------------------------------------------------------------------------

function doom_bringer_devour_omg:GrantPassive(modifier_name)
    local caster = self:GetCaster()

    table.insert(self.active_modifiers, caster:AddNewModifier(caster, self, modifier_name, {duration = -1}))
end

--------------------------------------------------------------------------------

function doom_bringer_devour_omg:ClearModifiers()
    for _, modifier in pairs(self.active_modifiers) do
        if modifier and not modifier:IsNull() then
            modifier:Destroy()
        end

        self.active_modifiers[_] = nil
    end
end

--------------------------------------------------------------------------------

modifier_doom_bringer_devour_omg = class({})

--------------------------------------------------------------------------------

function modifier_doom_bringer_devour_omg:IsPurgable()	    return false end
function modifier_doom_bringer_devour_omg:RemoveOnDeath()   return true end
function modifier_doom_bringer_devour_omg:GetAttributes()   return MODIFIER_ATTRIBUTE_MULTIPLE end

--------------------------------------------------------------------------------

function modifier_doom_bringer_devour_omg:OnCreated(kv)
    local ability = self:GetAbility()

    if not ability or ability:IsNull() then return end

    self.armor = ability:GetSpecialValueFor("armor")
    self.bonus_gold = ability:GetSpecialValueFor("bonus_gold") + self:GetCaster():FindTalentValue("special_bonus_unique_doom_3")
end

--------------------------------------------------------------------------------

function modifier_doom_bringer_devour_omg:OnDestroy()
    if IsServer() then
        if not self:GetAbility() or self:GetAbility():IsNull() then return end
        
        local parent = self:GetParent()

        if parent and parent:IsAlive() then
            parent:ModifyGold(self.bonus_gold, false, DOTA_ModifyGold_AbilityGold)
            EmitSoundOnEntityForPlayer("General.Coins", parent, parent:GetPlayerOwnerID())

            local gold_fx = ParticleManager:CreateParticleForPlayer("particles/msg_fx/msg_gold.vpcf", PATTACH_OVERHEAD_FOLLOW, parent, parent:GetPlayerOwner())
            ParticleManager:SetParticleControl(gold_fx, 1, Vector(0, self.bonus_gold, 0))
            ParticleManager:SetParticleControl(gold_fx, 2, Vector(1, #tostring(self.bonus_gold) + 1, 0))
            ParticleManager:SetParticleControl(gold_fx, 3, Vector(218, 165, 32))
            ParticleManager:ReleaseParticleIndex(gold_fx)
        end
    end
end

--------------------------------------------------------------------------------

function modifier_doom_bringer_devour_omg:DeclareFunctions()
    return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

--------------------------------------------------------------------------------

function modifier_doom_bringer_devour_omg:GetModifierPhysicalArmorBonus()
    return self.armor
end