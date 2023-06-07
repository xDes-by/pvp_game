LinkLuaModifier( "modifier_npc_dota_hero_axe_permanent_ability", "heroes/hero_axe/hero_axe", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_axe_permanent_ability = class({})

function npc_dota_hero_axe_permanent_ability:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function npc_dota_hero_axe_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

function npc_dota_hero_axe_permanent_ability:IsRefreshable()
	return false 
end

function npc_dota_hero_axe_permanent_ability:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_axe_permanent_ability"
end

--------------------------------------------------------------------------------

modifier_npc_dota_hero_axe_permanent_ability = class({})

function modifier_npc_dota_hero_axe_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_axe_permanent_ability:IsPurgable()
	return false
end

function modifier_npc_dota_hero_axe_permanent_ability:OnCreated( kv )
	self.str = self:GetAbility():GetSpecialValueFor( "str" )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.max_threshold = 10
	self.range = 100-self.max_threshold
	self.max_size = 45
	self:StartIntervalThink(1)
end

function modifier_npc_dota_hero_axe_permanent_ability:OnRefresh( kv )
	self.str = self:GetAbility():GetSpecialValueFor( "str" )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.max_threshold = 10
	self.range = 100-self.max_threshold
end

function modifier_npc_dota_hero_axe_permanent_ability:OnIntervalThink()
if not IsServer() then return end
	self:GetParent():CalculateStatBonus(true)
end

function modifier_npc_dota_hero_axe_permanent_ability:OnRemoved()
end

function modifier_npc_dota_hero_axe_permanent_ability:OnDestroy()
end

function modifier_npc_dota_hero_axe_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
	return funcs
end

function modifier_npc_dota_hero_axe_permanent_ability:GetModifierPhysicalArmorBonus()
	local pct = math.max((self:GetParent():GetHealthPercent()-self.max_threshold)/self.range,0)
	return (1-pct)*self.armor
end

function modifier_npc_dota_hero_axe_permanent_ability:GetModifierBonusStats_Strength()
	local pct = math.max((self:GetParent():GetHealthPercent()-self.max_threshold)/self.range,0)
	return (1-pct)*self.str
end


function modifier_npc_dota_hero_axe_permanent_ability:GetModifierModelScale()
	if IsServer() then
		local pct = math.max((self:GetParent():GetHealthPercent()-self.max_threshold)/self.range,0)
		return (1-pct)*self.max_size
	end
end