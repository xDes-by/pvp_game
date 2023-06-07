
LinkLuaModifier('modifier_npc_dota_hero_hoodwink_permanent_ability', "heroes/hero_hoodwink/hero_hoodwink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_hoodwink_permanent_ability_illusion_ture', "heroes/hero_hoodwink/hero_hoodwink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_hoodwink_permanent_ability_illusion_phis', "heroes/hero_hoodwink/hero_hoodwink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_hoodwink_permanent_ability_illusion_mage', "heroes/hero_hoodwink/hero_hoodwink", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_hoodwink_permanent_ability = class({})

function npc_dota_hero_hoodwink_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_hoodwink_permanent_ability'
end

function npc_dota_hero_hoodwink_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

modifier_npc_dota_hero_hoodwink_permanent_ability = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
	DeclareFunctions        = function(self) 
        return {
        	MODIFIER_EVENT_ON_ATTACK_LANDED,
        }
     end,
    OnAttackLanded = function(self,data)  
	    if (not self:GetParent():PassivesDisabled()) and data.attacker == self:GetParent() and self:GetAbility():GetSpecialValueFor("cance") > RandomInt(1, 100) then
            for i=1,3 do
                local illusions = CreateIllusions(self:GetCaster(), self:GetCaster(), {outgoing_damage = 1,incoming_damage = 300,duration = 10},1, 1, false, true)
	            local illusion = illusions[1]
                if i == 1 then
                    illusion:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_npc_dota_hero_hoodwink_permanent_ability_illusion_ture",{damage = self:GetParent():GetAverageTrueAttackDamage(self:GetParent())})
                elseif i == 2 then
                    illusion:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_npc_dota_hero_hoodwink_permanent_ability_illusion_phis",{damage = self:GetParent():GetAverageTrueAttackDamage(self:GetParent())})
                elseif i == 3 then
                    illusion:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_npc_dota_hero_hoodwink_permanent_ability_illusion_mage",{damage = self:GetParent():GetAverageTrueAttackDamage(self:GetParent())})
                end
            end
        end 
     end,
})
modifier_npc_dota_hero_hoodwink_permanent_ability_illusion_ture = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) 
        return {
        	MODIFIER_EVENT_ON_ATTACK_LANDED,
        }
     end,
    OnAttackLanded = function(self,data)  
	    if data.attacker:IsIllusion() and data.attacker:HasModifier("modifier_npc_dota_hero_hoodwink_permanent_ability_illusion_ture") then
            ApplyDamage({victim = data.target, attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_PURE,damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
            self:GetParent():ForceKill(true)
        end
     end,
})

modifier_npc_dota_hero_hoodwink_permanent_ability_illusion_phis = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) 
        return {
        	MODIFIER_EVENT_ON_ATTACK_LANDED,
        }
     end,
    OnAttackLanded = function(self,data)  
    if self:GetParent():PassivesDisabled() then return end
	    if data.attacker:IsIllusion() and data.attacker:HasModifier("modifier_npc_dota_hero_hoodwink_permanent_ability_illusion_phis") then
            ApplyDamage({victim = data.target, attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_PHYSICAL,damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
            self:GetParent():ForceKill(true)
        end
     end,
})

modifier_npc_dota_hero_hoodwink_permanent_ability_illusion_mage = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) 
        return {
        	MODIFIER_EVENT_ON_ATTACK_LANDED,
        }
     end,
    OnAttackLanded = function(self,data)  
	    if data.attacker:IsIllusion() and data.attacker:HasModifier("modifier_npc_dota_hero_hoodwink_permanent_ability_illusion_mage") then
            ApplyDamage({victim = data.target, attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL,damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
            self:GetParent():ForceKill(true)
        end
     end,
})