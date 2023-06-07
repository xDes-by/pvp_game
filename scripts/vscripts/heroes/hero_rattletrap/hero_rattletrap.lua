
LinkLuaModifier('modifier_npc_dota_hero_rattletrap_permanent_ability', "heroes/hero_rattletrap/hero_rattletrap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_rattletrap_permanent_ability_reflection', "heroes/hero_rattletrap/hero_rattletrap", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_rattletrap_permanent_ability = class({})

function npc_dota_hero_rattletrap_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_rattletrap_permanent_ability'
end

function npc_dota_hero_rattletrap_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

modifier_npc_dota_hero_rattletrap_permanent_ability = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
        }
    end,

    OnAbilityFullyCast = function(self,data) 
        if data.unit == self:GetParent() then
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_npc_dota_hero_rattletrap_permanent_ability_reflection", {duration = 2})
        end
    end,
})
modifier_npc_dota_hero_rattletrap_permanent_ability_reflection = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})

function modifier_npc_dota_hero_rattletrap_permanent_ability_reflection:GetEffectName()
	return "particles/items_fx/blademail.vpcf"
end

function modifier_npc_dota_hero_rattletrap_permanent_ability_reflection:GetStatusEffectName()
	return "particles/status_fx/status_effect_blademail.vpcf"
end

function modifier_npc_dota_hero_rattletrap_permanent_ability_reflection:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_npc_dota_hero_rattletrap_permanent_ability_reflection:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():EmitSound("DOTA_Item.BladeMail.Deactivate")
end

function modifier_npc_dota_hero_rattletrap_permanent_ability_reflection:OnTakeDamage(keys)
	if not IsServer() then return end
	if keys.unit == self:GetParent() and not keys.attacker:IsBuilding() and keys.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then	
		if not keys.unit:IsOther() then
			EmitSoundOnClient("DOTA_Item.BladeMail.Damage", keys.attacker:GetPlayerOwner())
		
			local damageTable = {
				victim			= keys.attacker,
				damage			= keys.original_damage * self:GetAbility():GetSpecialValueFor("return")*0.01,
				damage_type		= keys.damage_type,
				damage_flags	= DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				attacker		= self:GetParent(),
				ability			= self:GetAbility()
			}
			
			local reflectDamage = ApplyDamage(damageTable)
        end
    end

end
