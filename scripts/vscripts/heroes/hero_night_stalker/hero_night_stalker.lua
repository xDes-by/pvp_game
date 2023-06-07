LinkLuaModifier( "modifier_npc_dota_hero_night_stalker_permanent_ability", "heroes/hero_night_stalker/hero_night_stalker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_night_stalker_permanent_ability_effect", "heroes/hero_night_stalker/hero_night_stalker", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_night_stalker_permanent_ability = class({})

function npc_dota_hero_night_stalker_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_night_stalker_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_night_stalker_permanent_ability"
end

function npc_dota_hero_night_stalker_permanent_ability:GetCastRange()
if IsServer() then
		if (not GameRules:IsDaytime()) and  self:GetCaster():IsAlive() then
			return self:GetSpecialValueFor("radius_night")
		end
		if GameRules:IsDaytime()and self:GetCaster():IsAlive() then
			return self:GetSpecialValueFor("radius_day")
		end
	end
end

function npc_dota_hero_night_stalker_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_night_stalker_permanent_ability:IsRefreshable()
	return false 
end

---------------------------------------------------------------------------------------

modifier_npc_dota_hero_night_stalker_permanent_ability = class({})

function modifier_npc_dota_hero_night_stalker_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_night_stalker_permanent_ability:IsDebuff()
	return false
end

function modifier_npc_dota_hero_night_stalker_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_night_stalker_permanent_ability:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_npc_dota_hero_night_stalker_permanent_ability:GetModifierAura()
	return "modifier_npc_dota_hero_night_stalker_permanent_ability_effect"
end

function modifier_npc_dota_hero_night_stalker_permanent_ability:GetAuraRadius()
if IsServer() then
		if (not GameRules:IsDaytime()) and  self:GetCaster():IsAlive() then
			return self:GetAbility():GetSpecialValueFor("radius_night")
		end
		if GameRules:IsDaytime()and self:GetCaster():IsAlive() then
			return self:GetAbility():GetSpecialValueFor("radius_day")
		end
	end
end

function modifier_npc_dota_hero_night_stalker_permanent_ability:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_npc_dota_hero_night_stalker_permanent_ability:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

-------------------------------------------------------------

modifier_npc_dota_hero_night_stalker_permanent_ability_effect = class({})

function modifier_npc_dota_hero_night_stalker_permanent_ability_effect:IsHidden()
	return false
end

function modifier_npc_dota_hero_night_stalker_permanent_ability_effect:IsDebuff()
	return false
end

function modifier_npc_dota_hero_night_stalker_permanent_ability_effect:IsPurgable()
	return false
end

function modifier_npc_dota_hero_night_stalker_permanent_ability_effect:OnCreated( kv )
end

function modifier_npc_dota_hero_night_stalker_permanent_ability_effect:OnRefresh( kv )
end

function modifier_npc_dota_hero_night_stalker_permanent_ability_effect:OnDestroy( kv )
end


function modifier_npc_dota_hero_night_stalker_permanent_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}
	return funcs
end

function modifier_npc_dota_hero_night_stalker_permanent_ability_effect:GetModifierProvidesFOWVision( params )
	return 1
end



-- modifier_npc_dota_hero_night_stalker_permanent_ability = class({})

-- function modifier_npc_dota_hero_night_stalker_permanent_ability:IsHidden()
	-- return true
-- end

-- function modifier_npc_dota_hero_night_stalker_permanent_ability:IsPurgable()
	-- return false
-- end

-- function modifier_npc_dota_hero_night_stalker_permanent_ability:OnCreated( kv )
	-- self:StartIntervalThink(1)
-- end



-- function modifier_npc_dota_hero_night_stalker_permanent_ability:OnIntervalThink()
	-- if IsServer() then
		-- if (not GameRules:IsDaytime()) and  self:GetCaster():IsAlive() then --(not self:GetCaster():HasModifier("modifier_npc_dota_hero_night_stalker_permanent_ability_effect")) and
			-- self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_npc_dota_hero_night_stalker_permanent_ability_effect", {})
		-- end

		-- if GameRules:IsDaytime() and self:GetCaster():HasModifier("modifier_npc_dota_hero_night_stalker_permanent_ability_effect") and self:GetCaster():IsAlive() then
			-- self:GetCaster():RemoveModifierByName("modifier_npc_dota_hero_night_stalker_permanent_ability_effect")		
		-- end
	-- end
-- end

-----------------------------------------------------------------------------

-- modifier_npc_dota_hero_night_stalker_permanent_ability_effect = class({})

-- function modifier_npc_dota_hero_night_stalker_permanent_ability_effect:OnCreated()    
	-- self.armor = self:GetAbility():GetSpecialValueFor("armor")
	-- self.resist = self:GetAbility():GetSpecialValueFor("resist")
-- end

-- function modifier_npc_dota_hero_night_stalker_permanent_ability_effect:OnRefresh()
	-- self:OnCreated()
-- end

-- function modifier_npc_dota_hero_night_stalker_permanent_ability_effect:IsHidden() return false end
-- function modifier_npc_dota_hero_night_stalker_permanent_ability_effect:IsPurgable() return false end
-- function modifier_npc_dota_hero_night_stalker_permanent_ability_effect:IsDebuff() return false end

-- function modifier_npc_dota_hero_night_stalker_permanent_ability_effect:DeclareFunctions()
	-- local decFuncs = {
					  -- MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
					  -- MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
					  -- }
	-- return decFuncs
-- end


-- function modifier_npc_dota_hero_night_stalker_permanent_ability_effect:GetModifierPhysicalArmorBonus()
	-- if self:GetCaster():PassivesDisabled() then
		-- return nil
	-- end
	-- return self.armor
-- end

-- function modifier_npc_dota_hero_night_stalker_permanent_ability_effect:GetModifierMagicalResistanceBonus()
	-- if self:GetCaster():PassivesDisabled() then
		-- return nil
	-- end
	-- return self.resist
-- end