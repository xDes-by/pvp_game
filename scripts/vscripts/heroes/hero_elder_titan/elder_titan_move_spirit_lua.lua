elder_titan_move_spirit_lua = class({})

function elder_titan_move_spirit_lua:Spawn()
	if IsServer() then
		self:SetLevel(1)
		self:SetActivated(false)
	end
end

function elder_titan_move_spirit_lua:OnSpellStart()
	local pos = self:GetCursorPosition()
	local astral_spirit = self:GetCaster() and self:GetCaster().astral_spirit

	if astral_spirit and not astral_spirit:IsNull() and not astral_spirit.is_returning then
		astral_spirit:MoveToPosition(pos)
	end
end
