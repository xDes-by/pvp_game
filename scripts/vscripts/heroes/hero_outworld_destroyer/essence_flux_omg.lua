outworld_destroyer_essence_flux_omg = outworld_destroyer_essence_flux_omg or class({})

function outworld_destroyer_essence_flux_omg:GetIntrinsicModifierName()
    return "modifier_outworld_destroyer_essence_flux_omg"
end

LinkLuaModifier("modifier_outworld_destroyer_essence_flux_omg", "heroes/hero_outworld_destroyer/essence_flux_omg", LUA_MODIFIER_MOTION_NONE)

modifier_outworld_destroyer_essence_flux_omg = modifier_outworld_destroyer_essence_flux_omg or class({})

function modifier_outworld_destroyer_essence_flux_omg:IsHidden() return true end
function modifier_outworld_destroyer_essence_flux_omg:IsPurgable() return false end
function modifier_outworld_destroyer_essence_flux_omg:RemoveOnDeath() return false end

function modifier_outworld_destroyer_essence_flux_omg:OnCreated()
    self.exceptions = {
        obsidian_destroyer_arcane_orb = true,
    }

    self.ability = self:GetAbility()
    self:OnRefresh()
end

function modifier_outworld_destroyer_essence_flux_omg:OnRefresh()
    if not self.ability then
        self:Destroy()
        return
    end

    self.proc_chance = self.ability:GetSpecialValueFor("proc_chance")
    self.mana_restore = self.ability:GetSpecialValueFor("mana_restore")
end

function modifier_outworld_destroyer_essence_flux_omg:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
end

function modifier_outworld_destroyer_essence_flux_omg:OnAbilityExecuted(event)
    local parent = self:GetParent()

    local ability = event.ability

    if not ability or event.unit ~= parent or not self.proc_chance or not self.mana_restore or ability:IsItem() then return end
	
	if parent:PassivesDisabled() then return end

    local level = ability:GetLevel()

    local cooldown = ability:GetCooldown(level)
    local manacost = ability:GetManaCost(level)

    if (cooldown == 0 or (cooldown < 2 and manacost == 0) or ability:IsToggle()) and not self.exceptions[ability:GetAbilityName()] then return end

    if RollPercentage(self.proc_chance) then
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_ABSORIGIN, parent)
        ParticleManager:ReleaseParticleIndex(particle)

        parent:GiveMana(parent:GetMaxMana() * self.mana_restore * 0.01)
    end
end
