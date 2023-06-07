visage_gravekeepers_cloak_lua = class({})

function visage_gravekeepers_cloak_lua:GetIntrinsicModifierName()
	return "modifier_visage_gravekeepers_cloak"
end

function visage_gravekeepers_cloak_lua:GetBehavior()
	if self:GetCaster():HasShard() then return DOTA_ABILITY_BEHAVIOR_NO_TARGET end

	return DOTA_ABILITY_BEHAVIOR_PASSIVE 
end

function visage_gravekeepers_cloak_lua:OnSpellStart()

	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end
	
	if not caster:HasShard() then return end
	local shard_duration = self:GetSpecialValueFor("shard_duration")
	caster:AddNewModifier(caster, self, "modifier_visage_summon_familiars_stone_form_buff", {duration = shard_duration})
	caster:StartGesture( self:GetCastAnimation() )
end