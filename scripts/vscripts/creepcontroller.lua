if creepcontroller == nil then
	creepcontroller = class({})
end

function creepcontroller:Init()
	creepcontroller:creepSpawn()
	creepcontroller:towers()
	creepcontroller:guards()
end

_G.spawnInterval = 30
_G.Wave = 0
_G.Radiant_def_stage = 1
_G.Dire_def_stage = 1

-------------------------------------------------------------------------TOWERS----------------------------------------------------------------------------------

function creepcontroller:towers()
	local towers = {
		"dota_goodguys_tower1_top",
		"dota_goodguys_tower2_top",	
		"dota_goodguys_tower1_bot",
		"dota_goodguys_tower2_bot",	
		"dota_goodguys_tower1_mid",
		"dota_goodguys_tower2_mid",
		"dota_goodguys_tower4_bot",
		"dota_goodguys_tower4_top",
		"dota_badguys_tower1_top",
		"dota_badguys_tower2_top",	
		"dota_badguys_tower1_bot",
		"dota_badguys_tower2_bot",	
		"dota_badguys_tower1_mid",
		"dota_badguys_tower2_mid",
		"dota_badguys_tower4_top",
		"dota_badguys_tower4_bot"
	}
	for key,value in ipairs(towers) do
		local tower = Entities:FindByName( nil, value)
		tower:AddAbility("tower_attacks")
		tower:AddAbility("tower_split_shot")
	end
end

-------------------------------------------------------------------------GUARDS----------------------------------------------------------------------------------

function creepcontroller:guards()
	local point_dire = Entities:FindByName(nil, 'target_dire'):GetAbsOrigin()
	local unit = CreateUnitByName('dire_guard', point_dire, true, nil, nil, DOTA_TEAM_BADGUYS)
	local angle = unit:GetAngles()
	local new_angle = RotateOrientation(angle, QAngle(0, 180, 0))
	unit:SetAngles(new_angle[1], new_angle[2], new_angle[3])
	
	local point_radiant = Entities:FindByName(nil, 'target_radiant'):GetAbsOrigin()
	local unit = CreateUnitByName('radiant_guard', point_radiant, true, nil, nil, DOTA_TEAM_GOODGUYS)
end

-------------------------------------------------------------------------LINE CREEPS-----------------------------------------------------------------------------

function dire_math()
	print("!", _G.Dire_def_stage, "Dire_def_stage")
	_G.Dire_def_stage = _G.Dire_def_stage + 1
end

function radiant_math()
	print("!", _G.Radiant_def_stage, "Radiant_def_stage")
	_G.Radiant_def_stage = _G.Radiant_def_stage + 1
end

function creepcontroller:creepSpawn()
    Timers:CreateTimer(function()
	if GameRules:State_Get()>= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
    end
		self:SpawnCreeps()
		_G.Wave = _G.Wave + 1
		return _G.spawnInterval
	end)
end

function creepcontroller:SpawnCreeps()
	local RadiantCreepList = {"npc_dota_creep_goodguys_melee", "npc_dota_creep_goodguys_melee", "npc_dota_creep_goodguys_melee", "npc_dota_creep_goodguys_ranged"}
	local DireCreepList = {"npc_dota_creep_badguys_melee", "npc_dota_creep_badguys_melee", "npc_dota_creep_badguys_melee", "npc_dota_creep_badguys_ranged"}
	local AdditionalCreepsList = {
		['AdditionalRadiant'] = {"npc_dota_creep_goodguys_melee", "npc_dota_creep_goodguys_melee", "npc_dota_creep_goodguys_ranged", "npc_dota_goodguys_siege", "npc_dota_goodguys_siege"},
		['AdditionalDire'] = {"npc_dota_creep_badguys_melee", "npc_dota_creep_badguys_melee", "npc_dota_creep_badguys_ranged", "npc_dota_badguys_siege", "npc_dota_badguys_siege"}
	}

	if _G.Wave >= 11 and (_G.Wave - 11) % 10 == 0 then
		RadiantCreepList = {"npc_dota_creep_goodguys_melee", "npc_dota_creep_goodguys_melee", "npc_dota_creep_goodguys_melee", "npc_dota_creep_goodguys_ranged", "npc_dota_goodguys_siege"}
		DireCreepList = {"npc_dota_creep_badguys_melee", "npc_dota_creep_badguys_melee", "npc_dota_creep_badguys_melee", "npc_dota_creep_badguys_ranged", "npc_dota_badguys_siege"}
    end
	
	if _G.Wave >= 5 and (_G.Wave - 5) % 2 == 0 then
		RadiantCreepList[1] = "npc_dota_creep_goodguys_flagbearer"
		DireCreepList[1] = "npc_dota_creep_badguys_flagbearer"
	end
	
	AdditionalCreepsList["AdditionalRadiant"] = up_unit_stage(AdditionalCreepsList["AdditionalRadiant"], _G.Radiant_def_stage)
	AdditionalCreepsList["AdditionalDire"] = up_unit_stage(AdditionalCreepsList["AdditionalDire"], _G.Dire_def_stage)
	
	SpawnRadiantCreeps(up_unit_stage(RadiantCreepList, _G.Radiant_def_stage))
	SpawnDireCreeps(up_unit_stage(DireCreepList, _G.Dire_def_stage))
	AdditionalCreepsLogic(AdditionalCreepsList)
	creepcontroller:logic_neutrals()
end

function up_unit_stage(list, stage)
	if stage == 2 then
		for i, creepType in ipairs(list) do
			list[i] = creepType .. "_upgraded"
		end
	elseif stage == 3 then
		for i, creepType in ipairs(list) do
			list[i] = creepType .. "_upgraded_mega"
		end
	end
	return list
end

function SpawnRadiantCreeps(RadiantCreepList)
	local goodguys_spawn = Entities:FindByName(nil, "goodguys_spawn_mid"):GetAbsOrigin()
	local point = Entities:FindByName(nil, "lane_mid_pathcorner_goodguys_1")
	local delay = 0
	for _, creepName in pairs(RadiantCreepList) do
		Timers:CreateTimer(delay, function()
			unit = CreateUnitByName(creepName, goodguys_spawn, true, nil, nil, DOTA_TEAM_GOODGUYS)
			unit:SetInitialGoalEntity(point)
			up_creep(unit)
		end)
		delay = delay + 0.5
	end
end

function SpawnDireCreeps(DireCreepList)
	local badguys_spawn = Entities:FindByName(nil, "badguys_spawn_mid"):GetAbsOrigin()
	local point = Entities:FindByName(nil, "lane_mid_pathcorner_badguys_1")
	local delay = 0
	for _, creepName in pairs(DireCreepList) do
		Timers:CreateTimer(delay, function()
			unit = CreateUnitByName(creepName, badguys_spawn, true, nil, nil, DOTA_TEAM_BADGUYS)
			unit:SetInitialGoalEntity(point)
			up_creep(unit)
		end)
		delay = delay + 0.5
	end
end


function AdditionalCreepsLogic(AdditionalCreepsList)
	local spawnPoints = {
		["A"] = {"goodguys_spawn_top", "lane_top_pathcorner_goodguys_2"},
		["B"] = {"badguys_spawn_top","lane_top_pathcorner_badguys_2"},
		["C"] = {"badguys_spawn_bottom","lane_bottom_pathcorner_badguys_2"},
		["D"] = {"goodguys_spawn_bottom", "lane_bottom_pathcorner_goodguys_2"},
	}

	if (_G.Wave % 8 == 0) then
		SpawnAdditionalCreeps(spawnPoints["A"], spawnPoints["C"], AdditionalCreepsList)
	elseif (_G.Wave % 8 == 4) then
		SpawnAdditionalCreeps(spawnPoints["D"], spawnPoints["B"], AdditionalCreepsList)
	end
end

local AdditionalCreepsLast = {"npc_dota_neutral_kobold_taskmaster_custom", "npc_dota_neutral_forest_troll_high_priest_custom", "npc_dota_neutral_harpy_storm_custom", "npc_dota_neutral_alpha_wolf_custom",
"npc_dota_neutral_centaur_khan_custom", "npc_dota_neutral_satyr_soulstealer_custom", "npc_dota_neutral_ogre_mauler_custom", "npc_dota_neutral_polar_furbolg_ursa_warrior_custom", "npc_dota_neutral_enraged_wildkin_custom",
"npc_dota_neutral_warpine_raider_custom", "npc_dota_neutral_black_dragon_custom", "npc_dota_neutral_big_thunder_lizard_custom", "npc_dota_neutral_ice_shaman_custom", "npc_dota_neutral_granite_golem_custom"}

function SpawnAdditionalCreeps(radiant, dire, AdditionalCreepsList)
	if AdditionalCreepsLast[1] then 
		creep = AdditionalCreepsLast[1]
		table.remove_item(AdditionalCreepsLast, AdditionalCreepsLast[1])
	else
		creep = "npc_dota_neutral_granite_golem"
	end
	AdditionalCreepsList['AdditionalRadiant'][5] = creep
	AdditionalCreepsList['AdditionalDire'][5] = creep
	
	local delay = 0
	for i = 1, 5 do
		Timers:CreateTimer(delay, function()
			unit = CreateUnitByName(AdditionalCreepsList['AdditionalRadiant'][i], Entities:FindByName(nil, radiant[1]):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
			unit:SetInitialGoalEntity(Entities:FindByName(nil, radiant[2]))
			up_creep(unit)
			
			unit = CreateUnitByName(AdditionalCreepsList['AdditionalDire'][i], Entities:FindByName(nil, dire[1]):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
			unit:SetInitialGoalEntity(Entities:FindByName(nil, dire[2]))
			up_creep(unit)
		end)
		delay = delay + 0.5
	end
end

function up_creep(unit)
	local creep = unit:GetUnitName()
	if string.match(creep, "_upgraded_mega") then
		unit:SetBaseDamageMin(unit:GetBaseDamageMin() * 1.8)
		unit:SetBaseDamageMax(unit:GetBaseDamageMax() * 1.8)
		unit:SetMaxHealth(unit:GetMaxHealth() * 1.8)
		unit:SetBaseMaxHealth(unit:GetBaseMaxHealth() * 1.8)
		unit:SetHealth(unit:GetHealth() * 1.8)
	end
	if (_G.Wave % 10 == 0) then
		unit:SetBaseDamageMin(unit:GetBaseDamageMin() + _G.Wave/10)
		unit:SetBaseDamageMax(unit:GetBaseDamageMax() + _G.Wave/10)
		unit:SetMaxHealth(unit:GetMaxHealth() + _G.Wave/10 * 12)
		unit:SetBaseMaxHealth(unit:GetBaseMaxHealth() + _G.Wave/10 * 12)
		unit:SetHealth(unit:GetHealth() + _G.Wave/10 * 12)
	end
	
	unit:SetMaximumGoldBounty(unit:GetMaximumGoldBounty()/2)
	unit:SetMaximumGoldBounty(unit:GetMaximumGoldBounty()/2)
end

-------------------------------------------------------------------------NEUTRALS----------------------------------------------------------------------------------

function creepcontroller:logic_neutrals()
	local hRelay = Entities:FindByName( nil, "logic_neutrals" )
	hRelay:Trigger(nil,nil)
end

easy_camp = {
	[1] = {'npc_dota_neutral_kobold', 'npc_dota_neutral_kobold', 'npc_dota_neutral_kobold', 'npc_dota_neutral_kobold_tunneler', 'npc_dota_neutral_kobold_taskmaster'},
	[2] = {'npc_dota_neutral_forest_troll_high_priest','npc_dota_neutral_forest_troll_berserker', 'npc_dota_neutral_forest_troll_berserker'},
	[3] = {'npc_dota_neutral_forest_troll_berserker','npc_dota_neutral_forest_troll_berserker','npc_dota_neutral_kobold_taskmaster'},
	[4] = {'npc_dota_neutral_gnoll_assassin','npc_dota_neutral_gnoll_assassin','npc_dota_neutral_gnoll_assassin'},
	[5] = {'npc_dota_neutral_ghost','npc_dota_neutral_fel_beast','npc_dota_neutral_fel_beast'},
	[6] = {'npc_dota_neutral_harpy_scout','npc_dota_neutral_harpy_scout','npc_dota_neutral_harpy_storm'},
}

medium_camp = {
	[1] = {'npc_dota_neutral_centaur_outrunner','npc_dota_neutral_centaur_khan'},
	[2] = {'npc_dota_neutral_alpha_wolf','npc_dota_neutral_giant_wolf','npc_dota_neutral_giant_wolf'},
	[3] = {'npc_dota_neutral_satyr_soulstealer','npc_dota_neutral_satyr_soulstealer','npc_dota_neutral_satyr_trickster','npc_dota_neutral_satyr_trickster'},
	[4] = {'npc_dota_neutral_ogre_mauler','npc_dota_neutral_ogre_mauler','npc_dota_neutral_ogre_magi'},
	[5] = {'npc_dota_neutral_mud_golem','npc_dota_neutral_mud_golem'},
}

hard_camp = {
	[1] = {'npc_dota_neutral_centaur_khan','npc_dota_neutral_centaur_outrunner','npc_dota_neutral_centaur_outrunner'},
	[2] = {'npc_dota_neutral_polar_furbolg_champion','npc_dota_neutral_polar_furbolg_ursa_warrior'},
	[3] = {'npc_dota_neutral_wildkin','npc_dota_neutral_wildkin','npc_dota_neutral_enraged_wildkin'},
	[4] = {'npc_dota_neutral_dark_troll_warlord','npc_dota_neutral_dark_troll','npc_dota_neutral_dark_troll'},
	[5] = {'npc_dota_neutral_warpine_raider','npc_dota_neutral_warpine_raider'},
	[6] = {'npc_dota_neutral_satyr_soulstealer','npc_dota_neutral_satyr_hellcaller','npc_dota_neutral_satyr_trickster'},
}

ancient_camp = {
	[1] = {'npc_dota_neutral_black_drake','npc_dota_neutral_black_drake','npc_dota_neutral_black_dragon'},
	[2] = {'npc_dota_neutral_granite_golem','npc_dota_neutral_rock_golem','npc_dota_neutral_rock_golem'},
	[3] = {'npc_dota_neutral_big_thunder_lizard','npc_dota_neutral_small_thunder_lizard','npc_dota_neutral_small_thunder_lizard'},
	[4] = {'npc_dota_neutral_ice_shaman','npc_dota_neutral_frostbitten_golem', 'npc_dota_neutral_frostbitten_golem'},
}

function SpawnNeutrals()
	local triggerName = thisEntity:GetName()
	local name = string.gsub(triggerName, "_trigger", "")
	local point = Entities:FindByName(nil, name):GetAbsOrigin()
	local campType, campTable
	if string.match(triggerName, "easy") then
		campType, campTable = "easy", easy_camp
	elseif string.match(triggerName, "medium") then
		campType, campTable = "medium", medium_camp
	elseif string.match(triggerName, "hard") then
		campType, campTable = "hard", hard_camp
	elseif string.match(triggerName, "ancient") then
		campType, campTable = "ancient", ancient_camp
	end
	if campType then
		local arrayIndex = math.random(#campTable)
		local unitArray = campTable[arrayIndex]
		for _, unitName in ipairs(unitArray) do
			local unit = CreateUnitByName(unitName, point + RandomVector(RandomInt(20, 100)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		end
	end
end


------------------------------------------------------------------------TOP LINE----------------------------------------------------------------------------------

melee_radiant = {
	[1] = "models/creeps/lane_creeps/creep_radiant_melee/creep_radiant_melee.vmdl",
	[2] = "models/creeps/lane_creeps/creep_radiant_melee/radiant_melee_crystal.vmdl",
	[3] = "models/creeps/lane_creeps/creep_radiant_melee/radiant_melee_mega_crystal.vmdl",
	[4] = "models/creeps/lane_creeps/creep_2021_radiant/creep_2021_radiant_melee_mega.vmdl",
	[5] = "models/creeps/lane_creeps/ti9_chameleon_radiant/ti9_chameleon_radiant_melee_mega.vmdl",
	}	

range_radiant = {
	[1] = "models/creeps/lane_creeps/creep_radiant_ranged/radiant_ranged.vmdl",
	[2] = "models/creeps/lane_creeps/creep_radiant_ranged/crystal_radiant_ranged.vmdl",
	[3] = "models/creeps/lane_creeps/creep_radiant_ranged/radiant_ranged_mega_crystal.vmdl",
	[4] = "models/creeps/lane_creeps/creep_2021_radiant/creep_2021_radiant_ranged_mega.vmdl",
	[5] = "models/creeps/lane_creeps/ti9_chameleon_radiant/ti9_chameleon_radiant_ranged_mega.vmdl",
	}	

melee_dire = {
	[1] = "models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee.vmdl",
	[2] = "models/creeps/lane_creeps/nemestice_crystal_creeps/creep_bad_melee/creep_crystal_bad_melee.vmdl",
	[3] = "models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee_mega_crystal.vmdl",
	[4] = "models/creeps/lane_creeps/creep_2021_dire/creep_2021_dire_melee_mega.vmdl",
	[5] = "models/creeps/lane_creeps/ti9_crocodilian_dire/ti9_crocodilian_dire_melee_mega.vmdl",
	}	

range_dire = {
	[1] = "models/creeps/lane_creeps/creep_bad_ranged/lane_dire_ranged.vmdl",
	[2] = "models/creeps/lane_creeps/creep_bad_ranged/creep_bad_ranged_crystal.vmdl",
	[3] = "models/creeps/lane_creeps/creep_bad_ranged/creep_bad_ranged_mega_crystal.vmdl",
	[4] = "models/creeps/lane_creeps/creep_2021_dire/creep_2021_dire_ranged_mega.vmdl",
	[5] = "models/creeps/lane_creeps/ti9_crocodilian_dire/ti9_crocodilian_dire_ranged_mega.vmdl",
	}	

ursa = {
	[1] = "models/creeps/neutral_creeps/n_creep_eimermole/n_creep_eimermole.vmdl",
	[2] = "models/creeps/mega_greevil/mega_greevil.vmdl",
	[3] = "models/creeps/neutral_creeps/n_creep_beast/n_creep_beast.vmdl",
	[4] = "models/creeps/neutral_creeps/n_creep_furbolg/n_creep_furbolg_disrupter.vmdl",
	[5] = "models/creeps/neutral_creeps/n_creep_furbolg/n_creep_crystal_furbolg.vmdl",
	}

centaur = {
	[1] = "models/creeps/neutral_creeps/n_creep_centaur_med/n_creep_centaur_med.vmdl",
	[2] = "models/creeps/neutral_creeps/n_creep_centaur_lrg/n_creep_centaur_lrg.vmdl",
	[3] = "models/creeps/neutral_creeps/n_creep_centaur_lrg/neutral_stash_centaur.vmdl",
	[4] = "models/creeps/neutral_creeps/n_creep_dragonspawn_b/n_creep_dragonspawn_b.vmdl",
	[5] = "models/creeps/neutral_creeps/n_creep_dragonspawn_a/n_creep_dragonspawn_a.vmdl",
	}	
	
ogre = {
	[1] = "models/creeps/neutral_creeps/n_creep_ogre_lrg/n_creep_ogre_lrg.vmdl",
	[2] = "models/creeps/neutral_creeps/n_creep_ogre_med/n_creep_ogre_med.vmdl",
	[3] = "models/creeps/ogre_1/large_ogre.vmdl",
	[4] = "models/creeps/ogre_1/small_ogre.vmdl",
	[5] = "models/creeps/ogre_1/boss_ogre.vmdl",
	}		
	
satyr = {
	[1] = "models/creeps/neutral_creeps/n_creep_satyr_b/n_creep_satyr_b.vmdl",
	[2] = "models/creeps/neutral_creeps/n_creep_satyr_c/n_creep_satyr_c.vmdl",
	[3] = "models/creeps/neutral_creeps/n_creep_satyr_a/n_creep_satyr_a.vmdl",
	[4] = "models/creeps/neutral_creeps/n_creep_satyr_spawn_a/n_creep_satyr_spawn_b.vmdl",
	[5] = "models/creeps/neutral_creeps/n_creep_satyr_spawn_a/n_creep_satyr_spawn_a.vmdl",
	}			