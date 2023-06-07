require("libraries/table")
require("libraries/timers")
require("libraries/playertables")
require("libraries/notifications")

require("creepcontroller")
require("web")
require("holdout_card_points")

_G.key = "test_key"--GetDedicatedServerKeyV3("123")

if BattleMode == nil then
	BattleMode = class({})
end

Precache = require("libraries/precache")

function Activate()
	GameRules.BattleMode = BattleMode()
	GameRules.BattleMode:InitGameMode()
	ListenToGameEvent("dota_player_gained_level", LevelUp, nil)
end

function BattleMode:InitGameMode()	
	local GameModeEntity = GameRules:GetGameModeEntity()		
	GameRules:SetUseUniversalShopMode(false)
	GameRules:GetGameModeEntity():SetPauseEnabled(false)
	GameRules:SetSameHeroSelectionEnabled(false)	
	GameRules:LockCustomGameSetupTeamAssignment(true)
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled(true)
	GameRules:EnableCustomGameSetupAutoLaunch( true ) 
	GameRules:SetCustomGameSetupAutoLaunchDelay(5)
	GameRules:SetHeroSelectionTime(120010)
	GameRules:SetStrategyTime(10)
	GameRules:SetPreGameTime(10)
	GameRules:SetShowcaseTime(0)
	GameRules:SetPostGameTime(20)
	GameRules:SetTreeRegrowTime(30)
	GameRules:SetCustomGameEndDelay(160)
	GameRules:SetNeutralInitialSpawnOffset(9999)
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 5 )
	
	GameModeEntity:SetCustomBackpackCooldownPercent(1)
	GameModeEntity:SetUseDefaultDOTARuneSpawnLogic(false)
	GameModeEntity:SetPowerRuneSpawnInterval(120)
	GameModeEntity:SetBountyRuneSpawnInterval(120)
	GameModeEntity:SetRespawnTimeScale(0.5)
	
	-- GameModeEntity:SetItemAddedToInventoryFilter(Dynamic_Wrap( self, "AddedToInventoryFilter" ), context)

	ListenToGameEvent('npc_spawned', Dynamic_Wrap(BattleMode, 'OnNPCSpawned'), self)	
	ListenToGameEvent( "entity_killed", Dynamic_Wrap(BattleMode, 'OnEntityKilled' ), self )
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(BattleMode, 'OnGameStateChanged' ), self )
	ListenToGameEvent("dota_rune_activated_server",Dynamic_Wrap(BattleMode,'onRuneActivated'),self)
	ListenToGameEvent( "player_chat", Dynamic_Wrap(BattleMode, "OnChat" ), self )
	GameRules:GetGameModeEntity():SetExecuteOrderFilter(BattleMode.FilterExecuteOrder, self)
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 1 )	
end

function BattleMode:OnEntityKilled(keys)
    local killed_unit = EntIndexToHScript(keys.entindex_killed)
    local killer = EntIndexToHScript(keys.entindex_attacker)
	if killed_unit:GetUnitName() == "dire_guard" then
		local dire_base = Entities:FindByName( nil, "dota_badguys_fort")
		dire_base:ForceKill(false)
	end	
	if killed_unit:GetUnitName() == "radiant_guard" then
		local radiant_base = Entities:FindByName( nil, "dota_goodguys_fort")
		radiant_base:ForceKill(false)
	end	
end

function BattleMode:OnNPCSpawned(data)
	npc = EntIndexToHScript(data.entindex)
	if npc:IsRealHero() and npc.bFirstSpawned == nil and not npc:IsIllusion() and not npc:IsTempestDouble() and not npc:IsClone() and npc:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		npc.bFirstSpawned = true
		BattleMode:InitHero(npc)
	end
end

function BattleMode:InitHero(hero)
	for i = 0, hero:GetAbilityCount() - 1 do
		local ability = hero:GetAbilityByIndex(i)
		if ability and not ability:IsNull() then
			local ability_name = ability:GetAbilityName()
			if not string.find(ability_name, "special_bonus") and not table.contains({"ability_capture", "abyssal_underlord_portal_warp"}, ability_name) then
				hero:RemoveAbility(ability_name)
			end
		end
	end
	
	-- for _, index in pairs({0, 1, 2, 4, 5, 3}) do
		-- local new_ability = hero:AddAbility("empty_"..index)
	-- end
	
	hero:AddAbility(hero:GetName().."_permanent_ability"):SetLevel(1)
	holdout_card_points:Init()
end

function BattleMode:OnThink()
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:HasSelectedHero( nPlayerID ) then
			local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hero then
				if hero:HasScepter() then
					holdout_card_points:HasScepter(hero)
				else
					holdout_card_points:LostScepter(hero)
				end
			end	
		end
	end
	return 1
end

function LevelUp (eventInfo)
	local player = EntIndexToHScript( eventInfo.player )
	local player_id = player:GetPlayerID()
	local hero = PlayerResource:GetSelectedHeroEntity( player_id )
	if not hero then
		return 0.1
	end	
	
	holdout_card_points:_BuyCardPoints(player_id, 1)
	
	if hero:GetLevel() > 25 then
		hero:SetAbilityPoints(hero:GetAbilityPoints() + 2)
	end
end

function BattleMode:OnGameStateChanged()
    local state = GameRules:State_Get()
	if state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		web:init()
	elseif state == DOTA_GAMERULES_STATE_HERO_SELECTION then
	elseif state == DOTA_GAMERULES_STATE_STRATEGY_TIME then 	
	elseif state == DOTA_GAMERULES_STATE_TEAM_SHOWCASE then		
	elseif state == DOTA_GAMERULES_STATE_PRE_GAME then
	
	elseif state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		Timers:CreateTimer(function()
		if GameRules:IsDaytime() then
			GameRules:SetTimeOfDay(0.25)
		else
			GameRules:SetTimeOfDay(0.75)
		end
		return 300
	end)
	
	creepcontroller:Init()
	elseif state == DOTA_GAMERULES_STATE_POST_GAME then
	end
end

function BattleMode:onRuneActivated(keys)
	local playerID = keys.PlayerID
	local team = PlayerResource:GetTeam(playerID)
	local rune_type = tostring(keys.rune)
	local runeOwner = PlayerResource:GetSelectedHeroEntity( playerID )
	for i = 1, PlayerResource:GetPlayerCountForTeam(team) do
		local playerId = PlayerResource:GetNthPlayerIDOnTeam(team, i)
			if PlayerResource:IsValidTeamPlayerID(playerId) then
				if playerId ~= keys.PlayerID then 
				local hero = PlayerResource:GetSelectedHeroEntity( playerId )
				if hero:IsRealHero() then
					local buffList = {
						"modifier_rune_arcane",
						"modifier_rune_doubledamage",
						"modifier_rune_haste",
						"modifier_rune_invis",
						"modifier_rune_regen"
						}	
					hero:AddNewModifier(hero, nil, buffList[RandomInt(1, #buffList)], {duration = 30})
				end
			end
		end
	end
end

--------------------------------------------------------------------------
 
function BattleMode:OnChat(t)
	local text = t.text
	local hero = PlayerResource:GetSelectedHeroEntity( t.playerid )
	
	if text == "1" then
		web:start_game()
	end
	
	if text == "3" then
		hero:SetBaseIntellect(hero:GetBaseIntellect() + 1000000)
		hero:SetBaseAgility(hero:GetBaseAgility() + 1000000)
		hero:SetBaseStrength(hero:GetBaseStrength() + 1000000)	
	end
end

function BattleMode:FilterExecuteOrder(filterTable)
    local order = filterTable["order_type"]
	local pid = filterTable["issuer_player_id_const"]
	local hero = PlayerResource:GetSelectedHeroEntity(pid)
	local target = filterTable.entindex_target ~= 0 and EntIndexToHScript(filterTable.entindex_target) or nil
	local ability = EntIndexToHScript(filterTable["entindex_ability"])
	local pos_y = filterTable["position_y"]
	
	if hero and hero:IsRealHero() then
		if pos_y > 5630 then
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(filterTable.issuer_player_id_const), "CreateIngameErrorMessage", {message="#cant_use_roshan"})
			return 
		end
	end	
	return true
end



-- function BattleMode:FilterExecuteOrder(filterTable)
    -- local order = filterTable["order_type"]
	-- local pid = filterTable["issuer_player_id_const"]
	-- local hero = PlayerResource:GetSelectedHeroEntity(pid)
	-- local target = filterTable.entindex_target ~= 0 and EntIndexToHScript(filterTable.entindex_target) or nil
	-- local ability = EntIndexToHScript(filterTable["entindex_ability"])
	
	-- if hero ~= nil then
		-- if order == DOTA_UNIT_ORDER_MOVE_TO_POSITION and hero:HasModifier("modifier_item_teleport_lua") then 
			-- return
		-- end
		-- if order == DOTA_UNIT_ORDER_CAST_TARGET and target:HasAbility("roshan_slam") and ability:GetName() == "life_stealer_infest" then
			-- DisplayError(filterTable.issuer_player_id_const, "#cant_use_roshan")
			-- return
		-- end	
		-- if order == DOTA_UNIT_ORDER_CAST_TARGET and target:HasAbility("roshan_slam") and ability:GetName() == "doom_bringer_devour" then
			-- DisplayError(filterTable.issuer_player_id_const, "#cant_use_roshan")
			-- return
		-- end	
	-- end	
	
	-- if order == DOTA_UNIT_ORDER_TAKE_ITEM_FROM_NEUTRAL_ITEM_STASH  then 
		-- Timers:CreateTimer(0, function()
			-- local item = EntIndexToHScript(filterTable.entindex_ability)
			-- if hero:GetItemInSlot(DOTA_ITEM_NEUTRAL_SLOT) == nil then
				-- hero:SwapItems(item:GetItemSlot(), DOTA_ITEM_NEUTRAL_SLOT)
			-- elseif hero:GetItemInSlot(DOTA_ITEM_SLOT_7) == nil then 
				-- hero:SwapItems(item:GetItemSlot(), DOTA_ITEM_SLOT_7)
			-- elseif hero:GetItemInSlot(DOTA_ITEM_SLOT_8) == nil then 
				-- hero:SwapItems(item:GetItemSlot(), DOTA_ITEM_SLOT_8)
			-- elseif hero:GetItemInSlot(DOTA_ITEM_SLOT_9) == nil then 
				-- hero:SwapItems(item:GetItemSlot(), DOTA_ITEM_SLOT_9)
			-- end
		-- end)
	-- end	
	
	-- if order ==  DOTA_UNIT_ORDER_DROP_ITEM_AT_FOUNTAIN then 
		-- unit = EntIndexToHScript(filterTable.units["0"])
		-- if unit then 
			-- local playerID = hero:GetPlayerOwnerID()
			-- local team = hero:GetTeam()
			-- local item = EntIndexToHScript(filterTable.entindex_ability)
			-- if item:IsNeutralDrop() then 
				-- local newItem = CreateItem(item:GetAbilityName(), nil, nil) 
				-- PlayerResource:AddNeutralItemToStash(playerID,team, newItem)
				-- hero:RemoveItem(item)
				-- return false
			-- end
		-- end
	-- end
		
	-- if order == DOTA_UNIT_ORDER_PICKUP_ITEM then
		-- if not target then return true end
		-- local pickedItem = target:GetContainedItem()
		-- if not pickedItem then return true end
		-- local itemName = pickedItem:GetAbilityName()
		-- if itemName == "item_aegis" then
			-- if hero:HasItemInInventory("item_aegis") then
				-- DisplayError(filterTable.issuer_player_id_const, "#dota_hud_error_only_one_aegis")
				-- return false
			-- end
			-- if not hero:IsRealHero() then
				-- DisplayError(filterTable.issuer_player_id_const, "#dota_hud_error_non_hero_cant_pickup_aegis")
				-- return false
			-- end
		-- end
	-- end
	-- return true
-- end


-- function BattleMode:AddedToInventoryFilter(event )
	-- local unit=EntIndexToHScript(event.inventory_parent_entindex_const)
	-- local item=EntIndexToHScript(event.item_entindex_const)
	-- if IsRealPlayerHero(unit) then
		-- if item:IsNeutralDrop() or item.fromDrop == true then 
			-- item:SetPurchaser(unit)
		-- end
	-- end
	
	-- if unit ~= nil and unit:IsTempestDouble() then 
		-- if string.find(item:GetAbilityName(), "potion") ~= nil then 
			-- return false
		-- end
	-- end
	-- return true
-- end



