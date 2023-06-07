LinkLuaModifier( "modifier_pet_invis", "modifiers/pets/ai_pet", LUA_MODIFIER_MOTION_NONE )

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	
	thisEntity:SetContextThink( "BanditArcherThink", BanditArcherThink, 0.5 )
end

--------------------------------------------------------------------------------
function BanditArcherThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if thisEntity:GetOwner():IsInvisible() then
		if not thisEntity:HasModifier("modifier_pet_invis") then
			thisEntity:AddNewModifier(thisEntity,nil,"modifier_pet_invis",{})
		end	
	else
		if thisEntity:HasModifier("modifier_pet_invis") then
			thisEntity:RemoveModifierByName("modifier_pet_invis")
		end	
	end
	
	local flDist = ( thisEntity:GetOwner():GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist >= 400 and flDist < 900 then
				return Approach(thisEntity:GetOwner())
			end
			
			if flDist > 1000 then
				return blink(thisEntity:GetOwner())
			end
	return 0.2
end


function blink(unit)
	local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		thisEntity:SetAbsOrigin( unit:GetOrigin() + RandomVector( RandomInt(50, 50 ))  )
	})
	FindClearSpaceForUnit(thisEntity, unit:GetOrigin()+ RandomVector( RandomInt(50, 50 )), false)
	return 1
end

function Approach(unit)
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = unit:GetOrigin() + RandomVector( RandomFloat( 100, 150 ))
	})
	return 1
end


--------------------------------------------------------------------------

modifier_pet_invis = class({})

function modifier_pet_invis:IsDebuff() return false end
function modifier_pet_invis:IsHidden() return false end
function modifier_pet_invis:IsPurgable() return false end

function modifier_pet_invis:OnCreated()
end

function modifier_pet_invis:CheckState()
	return {
	[MODIFIER_STATE_INVISIBLE] = true,
	}
end

function modifier_pet_invis:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_pet_invis:GetModifierInvisibilityLevel()
	return 1
end