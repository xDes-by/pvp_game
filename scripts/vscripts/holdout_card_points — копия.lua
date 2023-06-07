holdout_card_points = class({})

_G._sellNoCostDuration = 10
_G._sellNoCostGametime = 0
_G._sellNoCostAbilityName = ""
_G._sellNoCostAbilityPrice = 1

_G.AllSceptersAbility = {
	["brewmaster_primal_companion"] = true,
	["centaur_mount"] = true,
	["rattletrap_overclocking"] = true,
	["enchantress_bunny_hop"] = true,
	["juggernaut_swift_slash"] = true,
	["ogre_magi_unrefined_fireblast"] = true,
	["snapfire_gobble_up"] = true,
	["snapfire_spit_creep"] = true,
};


local add_spells = {
	["elder_titan_return_spirit"] = true,
	["alchemist_unstable_concoction_throw"] = true,
	["beastmaster_call_of_the_wild_hawk"] = true,
	["wisp_tether_break"] = true,
	["kunkka_return"] = true,
}


function GetPlayerAbilityNumber(playerHero)
    local abilityNumber = 0
    for i = 0, 30 do
        local ability = playerHero:GetAbilityByIndex(i)
        if ability ~= nil then 
            local abilityName = ability:GetAbilityName()
            if AllSceptersAbility[abilityName] ~= true and add_spells[abilityName] ~= true and not string.match(abilityName, "special_bonus") and not string.match(abilityName, "empty_") and not string.match(abilityName, "ability_capture") and
			not string.match(abilityName, "abyssal_underlord_portal_warp") and not string.match(abilityName, "permanent_ability") then
                abilityNumber = abilityNumber + 1
				print(abilityName)
            end
        end
    end
	print("Ability count: ", abilityNumber)
    return abilityNumber
end

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

function holdout_card_points:HasScepter(hero)
	if hero then
		for i = 0, 30 do
		local ability = hero:GetAbilityByIndex(i)
			if ability ~= nil then 
			local abilityName = ability:GetAbilityName()
				if AllSceptersAbility[abilityName] == true then
					ability:SetHidden(false)
					print("show")
				end
			end
		end
	end
end

function holdout_card_points:LostScepter(hero)
	if hero then
		for i = 0, 30 do
		local ability = hero:GetAbilityByIndex(i)
			if ability ~= nil then 
			local abilityName = ability:GetAbilityName()
				if AllSceptersAbility[abilityName] == true then
					ability:SetHidden(true)
					print("hide")
				end
			end
		end
	end
end	
	
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------	

function holdout_card_points:Init()
    local playerIds = {}
    local playerPoints = {}

    local startingCardPoints = 10000
    for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
        playerIds[nPlayerID] = true
        playerPoints[nPlayerID] = startingCardPoints
    end

    PlayerTables:CreateTable("card_points", playerPoints, playerIds)

    CustomGameEventManager:RegisterListener("spells_menu_buy_spell", function(...)
        return self:_SpellsMenuBuySpell(...)
    end)

    CustomGameEventManager:RegisterListener("spells_menu_sell_spells", function(...)
        return self:_SpellsMenuSellGetSpells(...)
    end)

    CustomGameEventManager:RegisterListener("spells_menu_get_player_spells", function(...)
        return self:_SpellsMenuGetSpells(...)
    end)

    CustomGameEventManager:RegisterListener("spells_menu_sell_player_spells", function(...)
        return self:_SpellsMenuSellAbilities(...)
    end)

    CustomGameEventManager:RegisterListener("spells_menu_swap_player_spells", function(...)
        return self:_SpellsMenuSwapAbilitiesPosition(...)
    end)
end


function holdout_card_points:_RetrieveCardPoints(nPlayerID)
    if PlayerTables:TableExists("card_points") then
        return PlayerTables:GetTableValue("card_points", nPlayerID)
    end
    return 0
end

function holdout_card_points:_SetCardPoints(nPlayerID, cardPoints)
    if PlayerTables:TableExists("card_points") then
        PlayerTables:SetTableValue("card_points", nPlayerID, cardPoints)
    end
end

function holdout_card_points:_BuyCardPoints(nPlayerID, cardPoints)
    if PlayerTables:TableExists("card_points") then
        local player = PlayerResource:GetPlayer(nPlayerID)
        local newCardPoints = self:_RetrieveCardPoints(nPlayerID) + cardPoints
        self:_SetCardPoints(nPlayerID, newCardPoints)
        CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_buy_cardpoints_feedback", { new_card_points = newCardPoints })
        Notifications:Bottom(nPlayerID, { text = "#DOTA_HUD_Spells_Menu_Card_Point_Book_Used", duration = 4, style = { color = "green" } })
		
		-- DisplayError(filterTable.issuer_player_id_const, "#dota_hud_error_non_hero_cant_pickup_aegis")
    end
end

function holdout_card_points:_SpellsMenuBuySpell(eventSourceIndex, event_data)

    local nPlayerID = event_data.player_id
    local abilityName = event_data.spell_id
    local abilityCost = event_data.cost
    local additionalAbility = event_data.additional_spells
    local scepterAbility = event_data.scepter_ability
    local hero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
    local heroname = PlayerResource:GetSelectedHeroName(nPlayerID)
print("aa")
    if PlayerResource:HasSelectedHero(nPlayerID) then
	print("bb")
        local player = PlayerResource:GetPlayer(nPlayerID)
        local playerHero = player:GetAssignedHero()
        local cardPoints = 0
        cardPoints = self:_RetrieveCardPoints(nPlayerID)

        local SellAbilityCost = 3

        if playerHero:HasAbility(abilityName) then
		
            if hero:IsChanneling() 
                or hero:HasModifier("modifier_life_stealer_infest") 
                or hero:HasModifier("modifier_phoenix_sun") 
                or hero:HasModifier("modifier_phoenix_sun_ray") then

                Notifications:Bottom(nPlayerID, { text = "#DOTA_HUD_Spells_Menu_Not_Sell", duration = 4, style = { color = "red" } })
                hero:EmitSound("General.Cancel")
                return
            end

            if _sellNoCostAbilityName == abilityName and GameRules:GetGameTime() <= _sellNoCostGametime then
                SellAbilityCost = 0
            end

            if cardPoints < SellAbilityCost then
                Notifications:Bottom(nPlayerID, { text = "#DOTA_HUD_Spells_Menu_Not_Enough_CP", duration = 4, style = { color = "red" } })
                return
            end
			
			holdout_card_points:RemoveAbilityForEmpty(playerHero ,abilityName)

            local existingAbility = playerHero:FindAbilityByName(abilityName)
			playerHero:SetAbilityPoints(playerHero:GetAbilityPoints() + existingAbility:GetLevel())
            playerHero:RemoveAbilityByHandle(existingAbility)
			
            if additionalAbility then
				print("remove additional ability")
                for _, associatedAbilityName in pairs(additionalAbility) do
					holdout_card_points:RemoveAbilityForEmpty(playerHero ,associatedAbilityName)
					playerHero:RemoveAbility(associatedAbilityName)
                end
            end
            if scepterAbility then
				print("remove scepter ability")
                for _, associatedLearnableName in pairs(scepterAbility) do
                    local learnableAbility = playerHero:FindAbilityByName(associatedLearnableName)
					holdout_card_points:RemoveAbilityForEmpty(playerHero ,associatedLearnableName)
                    playerHero:RemoveAbilityByHandle(learnableAbility)
                end
            end

            local modifiers = hero:FindAllModifiers()
            for _, modifier in pairs(modifiers) do
                if modifier:GetAbility() == abilityName then
                    modifier:Destroy()
                end
            end

            if playerHero:HasModifier("modifier_"..abilityName) or playerHero:HasModifier("modifier_"..abilityName.."_aura") then
                playerHero:RemoveModifierByName("modifier_"..abilityName)
                playerHero:RemoveModifierByName("modifier_"..abilityName.."_aura")
            end
            -- playerHero:SetAbilityPoints(abilityPointsToSet)

            local newCardPoints = cardPoints - SellAbilityCost
            self:_SetCardPoints(nPlayerID, newCardPoints)

            Notifications:Bottom(nPlayerID, { text = "#DOTA_HUD_Spells_Menu_Successful_Refund", duration = 4, style = { color = "green" } })
            CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_buy_spell_feedback", { new_card_points = newCardPoints }) -- Close the menu
            local gameEvent = {}
            gameEvent["player_id"] = nPlayerID
            gameEvent["teamnumber"] = -1
            gameEvent["ability_name"] = abilityName
            gameEvent["message"] = "#Spells_Menu_SellAbility"
            FireGameEvent( "dota_combat_event_message", gameEvent )

            if _sellNoCostAbilityName == abilityName and GameRules:GetGameTime() <= _sellNoCostGametime then
                self:_BuyCardPoints(nPlayerID, _sellNoCostAbilityPrice)
                Notifications:Bottom(nPlayerID, { text = "#DOTA_HUD_Spells_Menu_no_cost_sell_feedback", duration = 4, style = { color = "green" } })
            end
        else
			local maxSlotNumber = 5
            if hero:HasModifier("modifier_item_mulberry") then
                local stack_count = hero:FindModifierByName("modifier_item_mulberry"):GetStackCount()
                maxSlotNumber = maxSlotNumber + stack_count
            end
            if GetPlayerAbilityNumber(playerHero) >= maxSlotNumber then
				Notifications:Bottom(nPlayerID, { text = "#DOTA_HUD_Spells_Menu_Not_Enough_Slot", duration = 4, style = { color = "red" } })
                return
            end

            local sameheroname = string.gsub(heroname,"npc_dota_hero_","")


            if heroname == "npc_dota_hero_sand_king" then
                sameheroname = "sandking"
            elseif heroname == "npc_dota_hero_spirit_breaker" then
                sameheroname = "spirit_breaker"
            end
            if string.match(abilityName, sameheroname) ~= nil then
                abilityCost = 0
            end

            if cardPoints < abilityCost then
                Notifications:Bottom(nPlayerID, { text = "#DOTA_HUD_Spells_Menu_Insufficient_CP", duration = 4, style = { color = "red" } })
                local gameEvent = {}
                gameEvent["player_id"] = nPlayerID
                gameEvent["teamnumber"] = -1
                gameEvent["ability_name"] = abilityName
                gameEvent["message"] = "#Spells_Menu_Insufficient_CP"
                FireGameEvent( "dota_combat_event_message", gameEvent )
                hero:EmitSound("General.Cancel")
                return
            end

            while (playerHero:HasAbility("generic_hidden"))
            do
                playerHero:RemoveAbility("generic_hidden")
            end
			
			 CustomGameEventManager:Send_ServerToPlayer(player, "dota_player_learned_ability", { player = player, abilityname = abilityName })
           -- newAbility:SetHidden(false)
			
			-- local secondAbility = playerHero:FindAbilityByName(playerHero:GetName().."_permanent_ability")
			-- playerHero:SwapAbilities(abilityName, playerHero:GetName().."_permanent_ability", not newAbility:IsHidden(), not secondAbility:IsHidden())
   
            if playerHero:HasModifier("modifier_"..abilityName) or playerHero:HasModifier("modifier_"..abilityName.."_aura") then
                playerHero:RemoveModifierByName("modifier_"..abilityName)
                playerHero:RemoveModifierByName("modifier_"..abilityName.."_aura")
                playerHero:RemoveModifierByName("modifier_"..abilityName.."_passive")
            end
            local modifiers = hero:FindAllModifiers()
            for _, modifier in pairs(modifiers) do
                if modifier:GetAbility() == abilityName then
                    modifier:Destroy()
                end
            end
			
            if additionalAbility then
            	print("add additional ability")
                for _, associatedAbilityName in pairs(additionalAbility) do
                    local associatedAbility = playerHero:AddAbility(associatedAbilityName)
                    associatedAbility:SetLevel(1)
                end
            end
			
            if scepterAbility then
			print("add scepter ability")
                for _, associatedLearnableName in pairs(scepterAbility) do
                    local associatedLearnable = playerHero:AddAbility(associatedLearnableName)
					associatedLearnable:SetLevel(1)

				--	associatedLearnable:SetAbilityIndex(ability:GetAbilityIndex())
					-- if playerHero:HasScepter() then
						-- associatedLearnable:SetHidden(false)
					-- else
						-- associatedLearnable:SetHidden(true)
					-- end
                end
            end


            local newCardPoints = cardPoints - abilityCost

            self:_SetCardPoints(nPlayerID, newCardPoints)
            Notifications:Bottom(nPlayerID, { text = "#DOTA_HUD_Spells_Menu_Successful_Purchase", duration = 4, style = { color = "green" } })
			
			print("new_card_points", newCardPoints)
            CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_buy_spell_feedback", { new_card_points = newCardPoints }) -- Close the menu
            local gameEvent = {}
            gameEvent["player_id"] = nPlayerID
            gameEvent["teamnumber"] = -1
            gameEvent["ability_name"] = abilityName
            gameEvent["message"] = "#Spells_Menu_PurchaseNewAbility"
            FireGameEvent( "dota_combat_event_message", gameEvent )
            hero:EmitSound("General.Buy")

            _sellNoCostAbilityName = abilityName
            _sellNoCostGametime = GameRules:GetGameTime() + _sellNoCostDuration
            _sellNoCostAbilityPrice = abilityCost
			    

				CustomGameEventManager:Send_ServerToPlayer(player, "dota_ability_changed", { entityIndex = playerHero })
			
						----------------------------------------------------------------------
			for i=0, maxSlotNumber - 1 do
				local slot_ability = hero:FindAbilityByName("empty_" .. i)

				if not slot_ability or slot_ability:IsNull() then
					slot_ability = hero:AddAbility("empty_" .. i)
				end

				if not slot_ability.used_placeholder then
					newAbility = playerHero:AddAbility(abilityName)
					hero:SwapAbilities(slot_ability:GetAbilityName(), newAbility:GetAbilityName(), false, true)
					newAbility:SetAbilityIndex(i)
					slot_ability.used_placeholder = true
					return
				end
			end
        end
	end	
end

function holdout_card_points:RemoveAbilityForEmpty(hero ,ability_name)
	local ability = hero:FindAbilityByName(ability_name)
	if not ability then return end
	local index = ability:GetAbilityIndex()

	if index <= 4 then
		hero:SwapAbilities(ability_name, "empty_" .. index, false, false)
	end

	local placeholder = hero:FindAbilityByName("empty_" .. index)
	if placeholder then
		placeholder.used_placeholder = nil
	end
end

function holdout_card_points:_SpellsMenuSellGetSpells(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    local playerAbilities = self:_GetPlayerSpells(nPlayerID)

    CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_sell_get_player_spells_feedback", { player_abilities = playerAbilities })
end

function holdout_card_points:_SpellsMenuGetSpells(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    local playerAbilities = self:_GetPlayerSpells(nPlayerID)

    CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_get_player_spells_feedback", { player_abilities = playerAbilities })
end

function holdout_card_points:_GetPlayerSpells(nPlayerID)
    local player = PlayerResource:GetPlayer(nPlayerID)
    if player and PlayerResource:HasSelectedHero(nPlayerID) then
        local playerHero = player:GetAssignedHero()
        local maxAbilities = playerHero:GetAbilityCount() - 1

        local playerAbilities = {}

        for ability_id = 0, maxAbilities do
            local ability = playerHero:GetAbilityByIndex(ability_id)
            -- Make sure it is not a talent and there is level
            if ability and not ability:IsAttributeBonus() and not ability:IsHidden() then
            -- if ability and not ability:IsAttributeBonus() then
                local abilityName = ability:GetAbilityName()
                table.insert(playerAbilities, abilityName)
            end
        end
        return playerAbilities
    end
    return {}
end

function holdout_card_points:_SpellsMenuSellAbilities(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local SellAbilityName = event_data.sellspellselected
    local player = PlayerResource:GetPlayer(nPlayerID)

    self:_SellAbilities(nPlayerID, SellAbilityName)

    -- CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_swap_player_spells_feedback", { })
end

function holdout_card_points:_SellAbilities(eventSourceIndex, SellAbilityName)
    local nPlayerID = event_data.player_id
    local abilityName = event_data.SellAbilityName
    local abilityCost = event_data.cost
    local additionalAbility = event_data.additional_spells
    local scepterAbility = event_data.scepter_ability

    if PlayerResource:HasSelectedHero(nPlayerID) then
        local player = PlayerResource:GetPlayer(nPlayerID)
        local playerHero = player:GetAssignedHero()
        local cardPoints = 0

        cardPoints = self:_RetrieveCardPoints(nPlayerID)

        if playerHero:HasAbility(abilityName) then

            local existingAbility = playerHero:FindAbilityByName(abilityName)

            playerHero:RemoveAbilityByHandle(existingAbility)
            if additionalAbility then
                -- Remove associated abilities
                for _, associatedAbilityName in pairs(additionalAbility) do
                    playerHero:RemoveAbility(associatedAbilityName)
                end
            end
            if scepterAbility then
                -- Remove associated learnables
                for _, associatedLearnableName in pairs(scepterAbility) do
                    -- refund points
                    local learnableAbility = playerHero:FindAbilityByName(associatedLearnableName)
                    playerHero:RemoveAbilityByHandle(learnableAbility)
                end
            end

            -- local newCardPoints = math.floor(cardPoints + abilityCost/2)
            local newCardPoints = cardPoints + abilityCost/2
            self:_SetCardPoints(nPlayerID, newCardPoints)
            Notifications:Bottom(nPlayerID, { text = "#DOTA_HUD_Spells_Menu_Successful_Refund", duration = 4, style = { color = "green" } })
            CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_buy_spell_feedback", { new_card_points = newCardPoints }) -- Close the menu
        end
    end
end

function holdout_card_points:_SpellsMenuSwapAbilitiesPosition(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local firstAbilityName = event_data.first_ability_name
    local secondAbilityName = event_data.second_ability_name
    local player = PlayerResource:GetPlayer(nPlayerID)
	self:_SwapAbilitiesPosition(nPlayerID, firstAbilityName, secondAbilityName)
	CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_swap_player_spells_feedback", { })
end

function holdout_card_points:_SwapAbilitiesPosition(nPlayerID, firstAbilityName, secondAbilityName)
    local player = PlayerResource:GetPlayer(nPlayerID)
    local playerHero = player:GetAssignedHero()
    local firstAbility = playerHero:FindAbilityByName(firstAbilityName)
    local secondAbility = playerHero:FindAbilityByName(secondAbilityName)

    if firstAbility and secondAbility then
        playerHero:SwapAbilities(firstAbilityName, secondAbilityName, not firstAbility:IsHidden(), not secondAbility:IsHidden())

        CustomGameEventManager:Send_ServerToPlayer(player, "dota_ability_changed", { entityIndex = playerHero })
    end
end