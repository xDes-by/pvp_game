
LinkLuaModifier('modifier_npc_dota_hero_elder_titan_permanent_ability', "heroes/hero_elder_titan/hero_elder_titan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_rattletrap_permanent_ability_reflection', "heroes/hero_elder_titan/hero_elder_titan", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_elder_titan_permanent_ability = class({})

function npc_dota_hero_elder_titan_permanent_ability:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_elder_titan_permanent_ability'
end

function npc_dota_hero_elder_titan_permanent_ability:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() < 10 then self:SetLevel(1) end
		if self:GetCaster():GetLevel() >= 10 and self:GetCaster():GetLevel() < 20 then self:SetLevel(2) end
		if self:GetCaster():GetLevel() >= 20 then self:SetLevel(3) end	
	end
end

modifier_npc_dota_hero_elder_titan_permanent_ability = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
})

function modifier_npc_dota_hero_elder_titan_permanent_ability:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(0.1)
    self.startPos = self:GetParent():GetOrigin()
    self.range = 0
end

function npc_dota_hero_elder_titan_permanent_ability:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_primal_beast.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_primal_beast/primal_beast_trample.vpcf", context )
end

function modifier_npc_dota_hero_elder_titan_permanent_ability:OnIntervalThink()
    if not IsServer() then return end
    self.endPos = self:GetParent():GetOrigin()
    local curRange = (self.startPos - self.endPos):Length2D() + self.range
    if curRange > self:GetAbility():GetSpecialValueFor("move") then
        self.startPos = self.endPos
	    local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(),self:GetParent():GetOrigin(),nil,self:GetAbility():GetSpecialValueFor("range"),DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,FIND_CLOSEST,false)
        for _,enemy in ipairs(enemies) do
	        ApplyDamage({victim = enemy, attacker = self:GetParent(), damage = self:GetAbility():GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL,damage_flags = DOTA_DAMAGE_FLAG_NONE})
        end
        self.range = 0
        local particle_cast = "particles/units/heroes/hero_primal_beast/primal_beast_trample.vpcf"
        local sound_cast = "Hero_PrimalBeast.Trample"
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self.parent )
        ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
        ParticleManager:ReleaseParticleIndex( effect_cast )
        EmitSoundOn( sound_cast, self.parent )
    else
        self.range = curRange + self.range
    end
end
