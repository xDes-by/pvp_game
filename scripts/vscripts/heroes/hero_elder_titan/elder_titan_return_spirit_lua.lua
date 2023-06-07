-- Return Spirit
elder_titan_return_spirit_lua = class({})

function elder_titan_return_spirit_lua:Spawn()
	if IsServer() then self:SetLevel(1) end
end

function elder_titan_return_spirit_lua:IsInnateAbility()
	return true
end

function elder_titan_return_spirit_lua:IsStealable() return false end
function elder_titan_return_spirit_lua:IsHiddenWhenStolen() return true end
function elder_titan_return_spirit_lua:ProcsMagicStick() return false end

function elder_titan_return_spirit_lua:OnSpellStart()
	local caster = self:GetCaster()

	-- This same ability is given to the spirit
	if not caster:IsRealHero() then
		caster = caster:GetOwner()
	end

	if caster and caster.astral_spirit and not caster.astral_spirit.is_returning then
		caster.astral_spirit:MoveToNPC(caster.astral_spirit:GetOwner())
		caster.astral_spirit.is_returning = true
		caster.astral_spirit:FindModifierByName("modifier_elder_titan_ancestral_spirit_lua"):SetStackCount(1)
		EmitSoundOn("Hero_ElderTitan.AncestralSpirit.Return", caster.astral_spirit)
	end
end
