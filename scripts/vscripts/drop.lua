if GameMode == nil then
	_G.GameMode = class({})
end

neutral_units =  {"badguys_siege_upgraded","badguys_siege","goodguys_siege_upgraded","goodguys_siege","team1_siege_upgraded","team1_siege","team2_siege_upgraded","team2_siege"}

items_drop_other = {{items = {"item_aegis","item_cheese","item_aghanims_shard_roshan","item_refresher_shard"}, chance = 100, duration = 60, units = {"goodguys_roshan","badguys_roshan","team1_roshan","team2_roshan"}},}

items_simple = {{items = {"item_flask","item_clarity","item_enchanted_mango"}, chance = 100, duration = 60, units = {"badguys_siege_upgraded","badguys_siege","goodguys_siege_upgraded","goodguys_siege","team1_siege_upgraded","team1_siege","team2_siege_upgraded","team2_siege"}},}

items_drop_lvl_1 = {
		{items = {"item_keen_optic","item_unstable_wand","item_royal_jelly","item_ocean_heart","item_broom_handle","item_pogo_stick","item_arcane_ring","item_mysterious_hat","item_possessed_mask","item_chipped_vest","item_ironwood_tree","item_faded_broach","item_iron_talon","item_trusty_shovel","item_mango_tree","item_dimensional_doorway"}, chance = 100, duration = 120, units =  {"badguys_siege_upgraded","badguys_siege","goodguys_siege_upgraded","goodguys_siege","team1_siege_upgraded","team1_siege","team2_siege_upgraded","team2_siege"}},	
}

items_drop_lvl_2 = {
		{items = {"item_grove_bow","item_ring_of_aquila","item_pupils_gift","item_misericorde","item_philosophers_stone","item_nether_shawl","item_dragon_scale","item_essence_ring","item_vambrace","item_dimensional_doorway","item_quicksilver_amulet","item_bullwhip","item_paintball","item_imp_claw","item_clumsy_net","item_vampire_fangs"}, chance = 100, duration = 120, units =  {"badguys_siege_upgraded","badguys_siege","goodguys_siege_upgraded","goodguys_siege","team1_siege_upgraded","team1_siege","team2_siege_upgraded","team2_siege"}},	
}

items_drop_lvl_3 = {
		{items = {"item_quickening_charm","item_mind_breaker","item_spider_legs","item_enchanted_quiver","item_paladin_sword","item_black_powder_bag","item_titan_sliver","item_horizon","item_elven_tunic","item_cloak_of_flames","item_psychic_headband","item_ceremonial_robe", "item_orb_of_destruction","item_craggy_coat","item_greater_faerie_fire","item_helm_of_the_undying","item_repair_kit","item_overflowing_elixir"}, chance = 100, duration = 120, units =  {"badguys_siege_upgraded","badguys_siege","goodguys_siege_upgraded","goodguys_siege","team1_siege_upgraded","team1_siege","team2_siege_upgraded","team2_siege"}},	
}

items_drop_lvl_4 = {
		{items = {"item_spy_gadget","item_timeless_relic","item_spell_prism","item_flicker","item_ninja_gear","item_ascetic_cap","item_the_leveller", "item_penta_edged_sword","item_stormcrafter","item_trickster_cloak","item_heavy_blade","item_illusionsts_cape","item_minotaur_horn","item_havoc_hammer","item_panic_button","item_princes_knife","item_witless_shako",}, chance = 100, duration = 120, units =  {"badguys_siege_upgraded","badguys_siege","goodguys_siege_upgraded","goodguys_siege","team1_siege_upgraded","team1_siege","team2_siege_upgraded","team2_siege"}},	
}

items_drop_lvl_5 = {
		{items = {"item_force_boots","item_desolator_2","item_seer_stone","item_mirror_shield","item_force_field","item_fallen_sky","item_pirate_hat","item_apex","item_book_of_shadows","item_giants_ring","item_phoenix_ash","item_woodland_striders","item_ex_machina",}, chance = 100, duration = 120, units =  {"badguys_siege_upgraded","badguys_siege","goodguys_siege_upgraded","goodguys_siege","team1_siege_upgraded","team1_siege","team2_siege_upgraded","team2_siege"}},	
}


function GameMode:InitGameMode()
	ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, 'OnEntityKilled'), self)
end

function GameMode:OnEntityKilled( keys )
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	local killerEntity = EntIndexToHScript( keys.entindex_attacker )
	local name = killedUnit:GetUnitName()
	local team = killedUnit:GetTeam()
	if killedUnit and not killedUnit:IsRealHero() and not killedUnit:IsControllableByAnyPlayer() then
	RollItemDropOther(killedUnit, killer)
		for _,current_name in pairs(neutral_units) do
			if current_name == killedUnit:GetUnitName() then
				if RandomInt(1,100) <= 80 then
					RollItemNeutrealDrop(killedUnit, killerEntity)
				else
					RollItemDrop(killedUnit, killerEntity)
				end	
			end
		end	
	end
end

function RollItemDropOther(unit, killer)
	local unit_name = unit:GetUnitName()

	for _,drop in ipairs(items_drop_other) do
		local items = drop.items or nil
		local items_num = #items
		local units = drop.units or nil 
		local chance = drop.chance or 100 
		local loot_duration = drop.duration or nil
		local limit = drop.limit or nil 
		local item_name = items[1]
		local roll_chance = RandomFloat(0, 100)
			
		if units then 
			for _,current_name in pairs(units) do
				if current_name == unit_name then
					units = nil
					break
				end
			end
		end

		if units == nil and (limit == nil or limit > 0) and roll_chance < chance then
			if limit then
				drop.limit = drop.limit - 1
			end

			if items_num > 1 then
				item_name = items[RandomInt(1, #items)]
			end	
			
			local newItem = CreateItem( item_name, nil, nil )
			local drop = CreateItemOnPositionForLaunch( unit:GetAbsOrigin(), newItem )
			local dropRadius = RandomFloat( 50, 100 )

			newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, unit:GetAbsOrigin() + RandomVector( dropRadius ) )
			if loot_duration then
				newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, loot_duration )
			end
		end
	end
end

function RollItemDrop(unit, killer)
	local unit_name = unit:GetUnitName()
	local items_drop = items_simple

	for _,drop in ipairs(items_drop) do
		local items = drop.items or nil
		local items_num = #items
		local units = drop.units or nil 
		local chance = drop.chance or 100 
		local loot_duration = drop.duration or nil
		local limit = drop.limit or nil 
		local item_name = items[1]
		local roll_chance = RandomFloat(0, 100)
			
		if units then 
			for _,current_name in pairs(units) do
				if current_name == unit_name then
					units = nil
					break
				end
			end
		end

		if units == nil and (limit == nil or limit > 0) and roll_chance < chance then
			if limit then
				drop.limit = drop.limit - 1
			end

			if items_num > 1 then
				item_name = items[RandomInt(1, #items)]
			end	
			
			local newItem = CreateItem( item_name, nil, nil )
			local drop = CreateItemOnPositionForLaunch( unit:GetAbsOrigin(), newItem )
			local dropRadius = RandomFloat( 50, 100 )

			newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, unit:GetAbsOrigin() + RandomVector( dropRadius ) )
			if loot_duration then
				newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, loot_duration )
			end
		end
	end
end

function RollItemNeutrealDrop(unit, killer)
	local unit_name = unit:GetUnitName()
	
	if _G.currentWave <= 12 then
		items_drop = items_drop_lvl_1
		tier = 1
	end
	if _G.currentWave > 12 and _G.currentWave <= 24 then
		items_drop = items_drop_lvl_2
		tier = 2
	end
	if _G.currentWave > 24 and _G.currentWave <= 36 then
		items_drop = items_drop_lvl_3
		tier = 3
	end
	if _G.currentWave > 36 and _G.currentWave <= 48 then
		items_drop = items_drop_lvl_4
		tier = 4
	end
	if _G.currentWave > 48 then
		local r = RandomInt(1,2)
		if r == 1 then
			items_drop = items_drop_lvl_4
			tier = 4
		end	
		if r == 2 then
			items_drop = items_drop_lvl_5
			tier = 5
		end	
	end
	
	for _,drop in ipairs(items_drop) do
		local items = drop.items or nil
		local items_num = #items
		local units = drop.units or nil 
		local chance = drop.chance or 100 
		local loot_duration = drop.duration or nil
		local limit = drop.limit or nil 
		local item_name = items[1]
		local roll_chance = RandomFloat(0, 100)
			
		if units then 
			for _,current_name in pairs(units) do
				if current_name == unit_name then
					units = nil
					break
				end
			end
		end

		if units == nil and (limit == nil or limit > 0) and roll_chance < chance then
			if limit then
				drop.limit = drop.limit - 1
			end

			if items_num > 1 then
				item_name = items[RandomInt(1, #items)]
			end
			
			DropNeutralItemAtPositionForHero(item_name, unit:GetAbsOrigin(), killer, tier, false)
		end
	end
end

function KillLoot( item, drop )
	if drop:IsNull() then
		return
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, drop )
	ParticleManager:SetParticleControl( nFXIndex, 0, drop:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	UTIL_Remove( item )
	UTIL_Remove( drop )
end

GameMode:InitGameMode()