_G.key = "9AE59FAD1DC21EDD426BA15CEDE4A9DDB91D9836"--GetDedicatedServerKeyV2("123")

_G.basicshop = {
    [1] = {
        name = 'one_game',
		[1] = {panorama_name = 'bonus_account', name = "bonus", price = {don = 30}, itemname = "item_bonus_lua", rarity = "#C48733", text_color = "#C48733", type='item'},
		[2] = {panorama_name = 'reset', name = "box_3", price = {don = 1000}, itemname = "reset",  image = "images/custom_game/reset.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='box', rare = "#B6E0E0"},
		
		[3] = {panorama_name = 'box', name = "box_1", price = {don = 500}, itemname = "box_1",  image = "images/custom_game/treasure1.png", desc = "1", rarity = "#C48733", text_color = "#C48733", type='box', box = "treasure1", rare = "#CF1E45"},
		[4] = {panorama_name = 'box', name = "box_2", price = {don = 750}, itemname = "box_2",  image = "images/custom_game/treasure2.png", desc = "1", rarity = "#C48733", text_color = "#C48733", type='box', box = "treasure2", rare = "#702391"},
		
		[5] = {panorama_name = 'panorama_bkb', name = "item_1", price = {don = 20}, itemname = "item_bkb_flask", rarity = "#C48733", text_color = "#C48733", type='item', combinable = true, consumabl = true},
		[6] = {panorama_name = 'panorama_passive', name = "item_2", price = {don = 20}, itemname = "item_passive_flask", rarity = "#C48733", text_color = "#C48733", type='item', combinable = true, consumabl = true},
		[7] = {panorama_name = 'panorama_creep_boost', name = "item_3", price = {don = 20}, itemname = "item_creep_boost", rarity = "#C48733", text_color = "#C48733", type='item', combinable = true, consumabl = true},
    },
	[2] = {
        name = 'sprays',
 		[1] = {panorama_name = 'spray', name = "spray_1", price = {don = 100}, itemname = "particles/sprays/gg.vpcf", image = "images/custom_game/sprays/gg.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', rare = "#B6E0E0"},
		[2] = {panorama_name = 'spray', name = "spray_2", price = {don = 100}, itemname = "particles/sprays/glomur.vpcf", image = "images/custom_game/sprays/glomur.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', rare = "#B6E0E0"},
		[3] = {panorama_name = 'spray', name = "spray_3", price = {don = 100}, itemname = "particles/sprays/guy2.vpcf", image = "images/custom_game/sprays/guy2.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', rare = "#B6E0E0"},
		[4] = {panorama_name = 'spray', name = "spray_4", price = {don = 100}, itemname = "particles/sprays/guy3.vpcf", image = "images/custom_game/sprays/guy3.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', rare = "#B6E0E0"},
		[5] = {panorama_name = 'spray', name = "spray_5", price = {don = 100}, itemname = "particles/sprays/tree.vpcf", image = "images/custom_game/sprays/tree.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', rare = "#B6E0E0"},
		[6] = {panorama_name = 'spray', name = "spray_6", price = {don = 100}, itemname = "particles/sprays/smashed.vpcf", image = "images/custom_game/sprays/smashed.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', rare = "#B6E0E0"},
		
		[7] = {panorama_name = 'spray', name = "spray_7", price = {don = 100}, itemname = "particles/sprays/tickle.vpcf", image = "images/custom_game/sprays/tickle.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[8] = {panorama_name = 'spray', name = "spray_8", price = {don = 100}, itemname = "particles/sprays/9000.vpcf", image = "images/custom_game/sprays/9000.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[9] = {panorama_name = 'spray', name = "spray_9", price = {don = 100}, itemname = "particles/sprays/axe.vpcf", image = "images/custom_game/sprays/axe.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[10] = {panorama_name = 'spray', name = "spray_10", price = {don = 100}, itemname = "particles/sprays/ball.vpcf", image = "images/custom_game/sprays/ball.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[11] = {panorama_name = 'spray', name = "spray_11", price = {don = 100}, itemname = "particles/sprays/bear.vpcf", image = "images/custom_game/sprays/bear.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[12] = {panorama_name = 'spray', name = "spray_12", price = {don = 100}, itemname = "particles/sprays/guy1.vpcf", image = "images/custom_game/sprays/guy1.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},		
		[13] = {panorama_name = 'spray', name = "spray_13", price = {don = 100}, itemname = "particles/sprays/hex.vpcf", image = "images/custom_game/sprays/hex.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},		
		[14] = {panorama_name = 'spray', name = "spray_14", price = {don = 100}, itemname = "particles/sprays/jug.vpcf", image = "images/custom_game/sprays/jug.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},		
		[15] = {panorama_name = 'spray', name = "spray_15", price = {don = 100}, itemname = "particles/sprays/lina.vpcf", image = "images/custom_game/sprays/lina.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},		
		[16] = {panorama_name = 'spray', name = "spray_16", price = {don = 100}, itemname = "particles/sprays/lion.vpcf", image = "images/custom_game/sprays/lion.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},		
		[17] = {panorama_name = 'spray', name = "spray_17", price = {don = 100}, itemname = "particles/sprays/pudge2.vpcf", image = "images/custom_game/sprays/pudge2.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},		
		[18] = {panorama_name = 'spray', name = "spray_18", price = {don = 100}, itemname = "particles/sprays/pudge.vpcf", image = "images/custom_game/sprays/pudge.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[19] = {panorama_name = 'spray', name = "spray_19", price = {don = 100}, itemname = "particles/sprays/ursa.vpcf", image = "images/custom_game/sprays/ursa.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[20] = {panorama_name = 'spray', name = "spray_20", price = {don = 100}, itemname = "particles/sprays/winner.vpcf", image = "images/custom_game/sprays/winner.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[21] = {panorama_name = 'spray', name = "spray_21", price = {don = 100}, itemname = "particles/sprays/zuus.vpcf", image = "images/custom_game/sprays/zuus.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},		
		[22] = {panorama_name = 'spray', name = "spray_22", price = {don = 100}, itemname = "particles/sprays/ogre.vpcf", image = "images/custom_game/sprays/ogre.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},		
		[23] = {panorama_name = 'spray', name = "spray_23", price = {don = 100}, itemname = "particles/sprays/mirana.vpcf", image = "images/custom_game/sprays/mirana.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},		
		[24] = {panorama_name = 'spray', name = "spray_24", price = {don = 100}, itemname = "particles/sprays/looser.vpcf", image = "images/custom_game/sprays/looser.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},		
		[25] = {panorama_name = 'spray', name = "spray_25", price = {don = 100}, itemname = "particles/sprays/sven.vpcf", image = "images/custom_game/sprays/sven.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[26] = {panorama_name = 'spray', name = "spray_26", price = {don = 100}, itemname = "particles/sprays/push.vpcf", image = "images/custom_game/sprays/push.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[27] = {panorama_name = 'spray', name = "spray_27", price = {don = 100}, itemname = "particles/sprays/shaman.vpcf", image = "images/custom_game/sprays/shaman.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[28] = {panorama_name = 'spray', name = "spray_28", price = {don = 100}, itemname = "particles/sprays/tusk.vpcf", image = "images/custom_game/sprays/tusk.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure1", rare = "#CF1E45"},		
			
		[29] = {panorama_name = 'spray', name = "spray_29", price = {don = 100}, itemname = "particles/sprays/boo.vpcf", image = "images/custom_game/sprays/boo.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
		[30] = {panorama_name = 'spray', name = "spray_30", price = {don = 100}, itemname = "particles/sprays/earth.vpcf", image = "images/custom_game/sprays/earth.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
		[31] = {panorama_name = 'spray', name = "spray_31", price = {don = 100}, itemname = "particles/sprays/egg.vpcf", image = "images/custom_game/sprays/egg.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
		[32] = {panorama_name = 'spray', name = "spray_32", price = {don = 100}, itemname = "particles/sprays/fura.vpcf", image = "images/custom_game/sprays/fura.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
		[33] = {panorama_name = 'spray', name = "spray_33", price = {don = 100}, itemname = "particles/sprays/hm.vpcf", image = "images/custom_game/sprays/hm.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
		[34] = {panorama_name = 'spray', name = "spray_34", price = {don = 100}, itemname = "particles/sprays/invoker.vpcf", image = "images/custom_game/sprays/invoker.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
		[35] = {panorama_name = 'spray', name = "spray_35", price = {don = 100}, itemname = "particles/sprays/marci.vpcf", image = "images/custom_game/sprays/marci.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
		[36] = {panorama_name = 'spray', name = "spray_36", price = {don = 100}, itemname = "particles/sprays/marci_meat.vpcf", image = "images/custom_game/sprays/marci_meat.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
		[37] = {panorama_name = 'spray', name = "spray_37", price = {don = 100}, itemname = "particles/sprays/marci2.vpcf", image = "images/custom_game/sprays/marci2.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
		[38] = {panorama_name = 'spray', name = "spray_38", price = {don = 100}, itemname = "particles/sprays/mars.vpcf", image = "images/custom_game/sprays/mars.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
		[39] = {panorama_name = 'spray', name = "spray_39", price = {don = 100}, itemname = "particles/sprays/meatball.vpcf", image = "images/custom_game/sprays/meatball.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
		[40] = {panorama_name = 'spray', name = "spray_40", price = {don = 100}, itemname = "particles/sprays/monkey.vpcf", image = "images/custom_game/sprays/monkey.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
		[41] = {panorama_name = 'spray', name = "spray_41", price = {don = 100}, itemname = "particles/sprays/old_school.vpcf", image = "images/custom_game/sprays/old_school.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
		[42] = {panorama_name = 'spray', name = "spray_42", price = {don = 100}, itemname = "particles/sprays/phantom_lancer.vpcf", image = "images/custom_game/sprays/phantom_lancer.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
		[43] = {panorama_name = 'spray', name = "spray_43", price = {don = 100}, itemname = "particles/sprays/pvp.vpcf", image = "images/custom_game/sprays/pvp.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
		[44] = {panorama_name = 'spray', name = "spray_44", price = {don = 100}, itemname = "particles/sprays/rip.vpcf", image = "images/custom_game/sprays/rip.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
		[45] = {panorama_name = 'spray', name = "spray_45", price = {don = 100}, itemname = "particles/sprays/rip2.vpcf", image = "images/custom_game/sprays/rip2.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
		[46] = {panorama_name = 'spray', name = "spray_46", price = {don = 100}, itemname = "particles/sprays/sf.vpcf", image = "images/custom_game/sprays/sf.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
		[47] = {panorama_name = 'spray', name = "spray_47", price = {don = 100}, itemname = "particles/sprays/tide.vpcf", image = "images/custom_game/sprays/tide.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},	
		[48] = {panorama_name = 'spray', name = "spray_48", price = {don = 100}, itemname = "particles/sprays/troll.vpcf", image = "images/custom_game/sprays/troll.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
		[49] = {panorama_name = 'spray', name = "spray_49", price = {don = 100}, itemname = "particles/sprays/ursa2.vpcf", image = "images/custom_game/sprays/ursa2.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
		[50] = {panorama_name = 'spray', name = "spray_50", price = {don = 100}, itemname = "particles/sprays/wow.vpcf", image = "images/custom_game/sprays/wow.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='spray', cant_buy = true, box = "treasure2", rare = "#702391"},
    },
	[3] = {
		name = "pets",
		[1] = {panorama_name = 'name_pet_mana_regen', name = "pet_1", price = {don = 1000}, itemname = "pet_mana_regen", image = "images/custom_game/pets/jumo.png", desc = "pet_mana_regen", rarity = "#C48733", text_color = "#C48733", type = "pet", rare = "#B6E0E0"},
		[2] = {panorama_name = 'name_pet_hp_regen', name = "pet_2", price = {don = 1000}, itemname = "pet_hp_regen", image = "images/custom_game/pets/panda.png", desc = "pet_hp_regen", rarity = "#C48733", text_color = "#C48733", type = "pet", rare = "#B6E0E0"},
		[3] = {panorama_name = 'name_pet_exp', name = "pet_3", price = {don = 1000}, itemname = "pet_exp", image = "images/custom_game/pets/wyrm.png", desc = "pet_exp", rarity = "#C48733", text_color = "#C48733", type = "pet", rare = "#B6E0E0"},
		[4] = {panorama_name = 'name_pet_speed', name = "pet_4", price = {don = 1000}, itemname = "pet_speed", image = "images/custom_game/pets/fox.png", desc = "pet_speed", rarity = "#C48733", text_color = "#C48733", type = "pet", cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[5] = {panorama_name = 'name_pet_fast', name = "pet_5", price = {don = 1000}, itemname = "pet_fast", image = "images/custom_game/pets/basim.png", desc = "pet_fast", rarity = "#C48733", text_color = "#C48733", type = "pet", cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[6] = {panorama_name = 'name_pet_income', name = "pet_6", price = {don = 1000}, itemname = "pet_income", image = "images/custom_game/pets/ram.png", desc = "pet_income", rarity = "#C48733", text_color = "#C48733", type = "pet", cant_buy = true, box = "treasure1", rare = "#CF1E45"},	
		[7] = {panorama_name = 'name_pet_hp', name = "pet_7", price = {don = 1000}, itemname = "pet_hp", image = "images/custom_game/pets/butch.png", desc = "pet_hp", rarity = "#C48733", text_color = "#C48733", type = "pet", cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[8] = {panorama_name = 'name_pet_spell_ampl', name = "pet_8", price = {don = 1000}, itemname = "pet_spell_ampl", image = "images/custom_game/pets/tur.png", desc = "pet_spell_ampl", rarity = "#C48733", text_color = "#C48733", type = "pet", cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[9] = {panorama_name = 'name_pet_out_damage', name = "pet_9", price = {don = 1000}, itemname = "pet_out_damage", image = "images/custom_game/pets/amaterasu.png", desc = "pet_out_damage", rarity = "#C48733", text_color = "#C48733", type = "pet", cant_buy = true, box = "treasure2", rare = "#702391"},
		[10] = {panorama_name = 'name_pet_cd', name = "pet_10", price = {don = 1000}, itemname = "pet_cd", image = "images/custom_game/pets/sky.png", desc = "pet_cd", rarity = "#C48733", text_color = "#C48733", type = "pet", cant_buy = true, box = "treasure2", rare = "#702391"},
		[11] = {panorama_name = 'name_pet_m_l', name = "pet_11", price = {don = 1000}, itemname = "pet_m_l", image = "images/custom_game/pets/dog.png", desc = "pet_m_l", rarity = "#C48733", text_color = "#C48733", type = "pet", cant_buy = true, box = "treasure2", rare = "#702391"},
		[12] = {panorama_name = 'name_pet_p_l', name = "pet_12", price = {don = 1000}, itemname = "pet_p_l", image = "images/custom_game/pets/luna.png", desc = "pet_p_l", rarity = "#C48733", text_color = "#C48733", type = "pet", cant_buy = true, box = "treasure2", rare = "#702391"},
	},
	[4] = {
 		name = "effects",
		[1] = {panorama_name = 'hero_effect', name = "effect_1", price = {don = 100}, itemname = "particles/econ/events/ti7/ti7_hero_effect_ring_aegis.vpcf", image = "images/custom_game/effects/1.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='effect', rare = "#B6E0E0"},
		[2] = {panorama_name = 'hero_effect', name = "effect_2", price = {don = 100}, itemname = "particles/econ/events/fall_major_2016/radiant_fountain_regen_fm06_lvl3_ring.vpcf", image = "images/custom_game/effects/2.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='effect', rare = "#B6E0E0"},
		[3] = {panorama_name = 'hero_effect', name = "effect_3", price = {don = 100}, itemname = "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff_gold_ring_fire.vpcf", image = "images/custom_game/effects/3.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='effect', rare = "#B6E0E0"},
		[4] = {panorama_name = 'hero_effect', name = "effect_4", price = {don = 100}, itemname = "particles/units/heroes/hero_vengeful/vengeful_shard_buff_ground_spike.vpcf", image = "images/custom_game/effects/4.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='effect', rare = "#B6E0E0"},
		[5] = {panorama_name = 'hero_effect', name = "effect_5", price = {don = 100}, itemname = "particles/items4_fx/ascetic_cap_ground_swirl.vpcf", image = "images/custom_game/effects/5.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='effect', rare = "#B6E0E0"},
		[6] = {panorama_name = 'hero_effect', name = "effect_6", price = {don = 100}, itemname = "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff_ring_fire.vpcf", image = "images/custom_game/effects/6.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='effect', rare = "#B6E0E0"},
		[7] = {panorama_name = 'hero_effect', name = "effect_7", price = {don = 100}, itemname = "particles/units/heroes/hero_void_spirit/planeshift/void_spirit_planeshift_untargetable_ground.vpcf", image = "images/custom_game/effects/7.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='effect', rare = "#B6E0E0"},
		[8] = {panorama_name = 'hero_effect', name = "effect_8", price = {don = 100}, itemname = "particles/units/heroes/hero_silencer/silencer_last_word_status_ring_ember.vpcf", image = "images/custom_game/effects/8.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='effect', rare = "#B6E0E0"},
	
		[9] = {panorama_name = 'hero_effect', name = "effect_9", price = {don = 100}, itemname = "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_focusfire_ground_rope.vpcf", image = "images/custom_game/effects/9.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='effect', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[10] = {panorama_name = 'hero_effect', name = "effect_10", price = {don = 100}, itemname = "particles/econ/events/spring_2021/agh_aura_spring_2021_lvl2.vpcf", image = "images/custom_game/effects/10.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='effect', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[11] = {panorama_name = 'hero_effect', name = "effect_11", price = {don = 100}, itemname = "particles/econ/events/spring_2021/teleport_start_spring_2021_energy.vpcf", image = "images/custom_game/effects/11.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='effect', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[12] = {panorama_name = 'hero_effect', name = "effect_12", price = {don = 100}, itemname = "particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ghost_ship_marker_splash_ring.vpcf", image = "images/custom_game/effects/12.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='effect', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[13] = {panorama_name = 'hero_effect', name = "effect_13", price = {don = 100}, itemname = "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_ground_eztzhok.vpcf", image = "images/custom_game/effects/13.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='effect', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[14] = {panorama_name = 'hero_effect', name = "effect_14", price = {don = 100}, itemname = "particles/econ/items/enchantress/enchantress_2021_crimson/enchantress_2021_crimson_ground_plants.vpcf", image = "images/custom_game/effects/14.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='effect', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[15] = {panorama_name = 'hero_effect', name = "effect_15", price = {don = 100}, itemname = "particles/econ/items/enchantress/enchantress_2021_immortal/enchantress_2021_immortal_ground_plants_flowers_a.vpcf", image = "images/custom_game/effects/15.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='effect', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[16] = {panorama_name = 'hero_effect', name = "effect_16", price = {don = 100}, itemname = "particles/econ/items/effigies/status_fx_effigies/ambientfx_effigy_wm16_dire_lvl3.vpcf", image = "images/custom_game/effects/16.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='effect', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[17] = {panorama_name = 'hero_effect', name = "effect_17", price = {don = 100}, itemname = "particles/econ/events/spring_2021/groundglow_spring_2021.vpcf", image = "images/custom_game/effects/17.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='effect', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		[18] = {panorama_name = 'hero_effect', name = "effect_18", price = {don = 100}, itemname = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner_status.vpcf", image = "images/custom_game/effects/18.png", desc = "1" , rarity = "#C48733", text_color = "#C48733", type='effect', cant_buy = true, box = "treasure1", rare = "#CF1E45"},
		
 		[19] = {panorama_name = 'hero_effect',name = "effect_19", price = {don = 100}, itemname = "particles/econ/events/diretide_2020/emblem/fall20_emblem_effect.vpcf", image = "images/custom_game/effects/gold.png", desc = "1" , rarity = "#C48733", type = "effect", cant_buy = true, box = "treasure2", rare = "#702391"},
 		[20] = {panorama_name = 'hero_effect',name = "effect_20", price = {don = 100}, itemname = "particles/econ/events/diretide_2020/emblem/fall20_emblem_v1_effect.vpcf", image = "images/custom_game/effects/green.png", desc = "1" , rarity = "#C48733", type = "effect", cant_buy = true, box = "treasure2", rare = "#702391"},
 		[21] = {panorama_name = 'hero_effect',name = "effect_21", price = {don = 250}, itemname = "particles/econ/events/diretide_2020/emblem/fall20_emblem_v2_effect.vpcf", image = "images/custom_game/effects/red.png", desc = "1" , rarity = "#C48733", type = "effect", cant_buy = true, box = "treasure2", rare = "#702391"},
 		[22] = {panorama_name = 'hero_effect',name = "effect_22", price = {don = 250}, itemname = "particles/econ/events/diretide_2020/emblem/fall20_emblem_v3_effect.vpcf", image = "images/custom_game/effects/blue.png", desc = "1" , rarity = "#C48733", type = "effect", cant_buy = true, box = "treasure2", rare = "#702391"},
 		[23] = {panorama_name = 'hero_effect',name = "effect_23", price = {don = 250}, itemname = "particles/econ/events/fall_2021/fall_2021_emblem_game_effect.vpcf", image = "images/custom_game/effects/em_agh.png", desc = "1" , rarity = "#C48733", type = "effect", cant_buy = true, box = "treasure2", rare = "#702391"},
 		[24] = {panorama_name = 'hero_effect',name = "effect_24", price = {don = 250}, itemname = "particles/econ/events/summer_2021/summer_2021_emblem_effect.vpcf", image = "images/custom_game/effects/em_grass.png", desc = "1" , rarity = "#C48733", type = "effect", cant_buy = true, box = "treasure2", rare = "#702391"},
 		[25] = {panorama_name = 'hero_effect',name = "effect_25", price = {don = 250}, itemname = "particles/econ/events/ti10/emblem/ti10_emblem_effect.vpcf", image = "images/custom_game/effects/em_dark.png", desc = "1" , rarity = "#C48733", type = "effect", cant_buy = true, box = "treasure2", rare = "#702391"},
 		[26] = {panorama_name = 'hero_effect',name = "effect_26", price = {don = 250}, itemname = "particles/econ/events/ti7/ti7_hero_effect.vpcf", image = "images/custom_game/effects/em_blue.png", desc = "1" , rarity = "#C48733", type = "effect", cant_buy = true, box = "treasure2", rare = "#702391"},
 		[27] = {panorama_name = 'hero_effect',name = "effect_27", price = {don = 250}, itemname = "particles/econ/events/ti8/ti8_hero_effect.vpcf", image = "images/custom_game/effects/em_green.png", desc = "1" , rarity = "#C48733", type = "effect", cant_buy = true, box = "treasure2", rare = "#702391"},
 		[28] = {panorama_name = 'hero_effect',name = "effect_28", price = {don = 250}, itemname = "particles/econ/events/ti9/ti9_emblem_effect.vpcf", image = "images/custom_game/effects/em_viol.png", desc = "1" , rarity = "#C48733", type = "effect", cant_buy = true, box = "treasure2", rare = "#702391"},
 	}
}

if Shop == nil then
    _G.Shop = class({})
end

function Shop:init()
	Shop.pShop = {}
    CustomGameEventManager:RegisterListener("eventopenbox", Dynamic_Wrap( Shop, 'eventopenbox' ))
    CustomGameEventManager:RegisterListener("giveItem", Dynamic_Wrap( Shop, 'giveItem' ))
	CustomGameEventManager:RegisterListener("buyItem", Dynamic_Wrap( Shop, 'buyItem' ))
    CustomGameEventManager:RegisterListener("takeOffEffect", Dynamic_Wrap( Shop, 'takeOffEffect' ))
    CustomGameEventManager:RegisterListener("return_item", Dynamic_Wrap( Shop, 'return_item' ))
	ListenToGameEvent("player_reconnected", Dynamic_Wrap( Shop, 'OnPlayerReconnected' ), self)
	ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( Shop, 'OnGameRulesStateChange'), self)
	vis_effect = {}
end

--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
--40/30/5/25
loot_1 = {
	{5,6,7,8,9,10,11,12,13,14,15,16,17,18,19}, -- other
	{7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28}, --spray
	{5,6,7,8}, --pets
	{9,10,11,12,13,14,15,16,17,18} --effect
	}
	
loot_2 = {
	{5,6,7,8,9,10,11,12,13,14,15,16,17,18,19}, -- other
	{29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50}, --spray
	{9,10,11,12}, --pets
	{19,20,21,22,23,24,25,26,27,28} --effect
	}	

function Shop:eventopenbox(t)
local hero = PlayerResource:GetSelectedHeroEntity( t.PlayerID )
send_gift = {}
send_key = {}
send_value = {}	
new_items = {}
total_exp = 0
	
	local box = nil
	
	if t.box == "reset" then
		Shop:accreset({playerID = t.PlayerID})
	end
	
	if t.box == "box_1" then
		box = loot_1
	end
	
	if t.box == "box_2" then
		box = loot_2
	end
	
	if box ~= nil then
		for i = 1, 5 do
			local rand = RandomInt(0,100)
			if rand < 40 then
				loot_block = box[1]
				block = 1
			elseif rand >= 40 and rand < 70 then 	
				loot_block = box[2]
				block = 2
			elseif rand >= 70 and rand < 75 then 	
				loot_block = box[3]
				block = 3
			else
				loot_block = box[4]
				block = 4
			end
			item_number = loot_block[RandomInt(1,#loot_block)]	
			send_key[i] = block
			send_value[i] = item_number
			
				if Shop.pShop[t.PlayerID][block][item_number].type == 'pet' and Shop.pShop[t.PlayerID][block][item_number]['now'] >= 6 then
					print("full pet")
					local exp_taik = RandomInt(200,300)
					total_exp = total_exp + exp_taik
					send_gift[i] = {exp_reward = exp_taik}
				elseif Shop.pShop[t.PlayerID][block][item_number].type == 'pet' and Shop.pShop[t.PlayerID][block][item_number]['now'] < 6 then
					Shop.pShop[t.PlayerID][block][item_number]['now'] = tonumber(Shop.pShop[t.PlayerID][block][item_number]['now']) + 1
				print("add_pet")
					local pet_now = hero:FindModifierByName("modifier_"..Shop.pShop[t.PlayerID][block][item_number].itemname)
						if pet_now ~= nil then
							hero:SetModifierStackCount("modifier_"..Shop.pShop[t.PlayerID][block][item_number].itemname, hero, hero:GetModifierStackCount("modifier_"..Shop.pShop[t.PlayerID][block][item_number].itemname, hero) + 1 )
						end
					local give = {}
					give[Shop.pShop[t.PlayerID][block][item_number].name] = 1
					new_items[i] = Shop.pShop[t.PlayerID][block][item_number].name
					send_gift[i] = Shop.pShop[t.PlayerID][block][item_number]	
				elseif Shop.pShop[t.PlayerID][block][item_number].type == 'effect' and Shop.pShop[t.PlayerID][block][item_number]['now'] == 1 then
					print("u has this effect")
					local exp_taik = RandomInt(50,100)
					total_exp = total_exp + exp_taik
					send_gift[i] = {exp_reward = exp_taik}	
				elseif Shop.pShop[t.PlayerID][block][item_number].type == 'spray' and Shop.pShop[t.PlayerID][block][item_number]['now'] == 1 then
					print("u has this spray")
					local exp_taik = RandomInt(50,100)
					total_exp = total_exp + exp_taik
					send_gift[i] = {exp_reward = exp_taik}
				elseif Shop.pShop[t.PlayerID][block][item_number].type == 'item' and Shop.pShop[t.PlayerID][block][item_number]['now'] > 0 and Shop.pShop[t.PlayerID][tonumber(block)][tonumber(item_number)]['status'] ~= "consumabl" then
					print("u has this item")
					local exp_taik = RandomInt(50,100)
					total_exp = total_exp + exp_taik
					send_gift[i] = {exp_reward = exp_taik}	
				elseif Shop.pShop[t.PlayerID][tonumber(block)][tonumber(item_number)]['status'] ~= "consumabl" and Shop.pShop[t.PlayerID][block][item_number]['now'] == 0 then 
					print("add_item")
					Shop.pShop[t.PlayerID][block][item_number]['now'] = tonumber(Shop.pShop[t.PlayerID][block][item_number]['now']) + 1
					local give = {}
					give[Shop.pShop[t.PlayerID][block][item_number].name] = 1
					new_items[i] = Shop.pShop[t.PlayerID][block][item_number].name
					send_gift[i] = Shop.pShop[t.PlayerID][block][item_number]
				elseif Shop.pShop[t.PlayerID][tonumber(block)][tonumber(item_number)]['status'] == "consumabl" then 
					print("add_item_stack")
					print(Shop.pShop[t.PlayerID][block][item_number]['now'])
					Shop.pShop[t.PlayerID][block][item_number]['now'] = tonumber(Shop.pShop[t.PlayerID][block][item_number]['now']) + 1
					local give = {}
					give[Shop.pShop[t.PlayerID][block][item_number].name] = 1
					new_items[i] = Shop.pShop[t.PlayerID][block][item_number].name
					send_gift[i] = Shop.pShop[t.PlayerID][block][item_number]
				end
			end
			print("1111111111111111111111")
		add_box_reward(total_exp,t.PlayerID, new_items, t.box)
			print("1111111111111111111111")
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.PlayerID), "openbox", {send_gift, send_key, send_value})		
	end
end

function add_box_reward(xp,playerid, new_items, box)
print("===========================================")
print(xp)
print(playerid)
print(new_items[1])
print(new_items[2])
print(new_items[3])
print(new_items[4])
print(new_items[5])
print(box)
print("===========================================")
	if xp == nil then
		xp = 0
	end
	local sid = PlayerResource:GetSteamAccountID(playerid)
	local sid2 = PlayerResource:GetSteamID(playerid)
	if math.floor((acc.arr[sid][1].player_exp + xp)/1000) > math.floor(acc.arr[sid][1].player_exp/1000) then
		local lvl_now = 1 + math.floor(acc.arr[sid][1].player_exp /1000) 
		local lvl = 1 + math.floor((acc.arr[sid][1].player_exp + xp)/1000)
		local point_add = lvl - lvl_now
		acc.arr[sid][1].player_exp = acc.arr[sid][1].player_exp + xp
		acc.arr[sid][1].player_level = lvl
		acc.arr[sid][1].point = acc.arr[sid][1].point + point_add
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( playerid ), "initaccount", acc.arr[sid][1] )	
		Shop:box_request({sid = sid2, expa = xp, player_level = lvl, point = point_add, item1 = new_items[1],item2 = new_items[2],item3 = new_items[3],item4 = new_items[4],item5 = new_items[5], box = box})		
	else
		acc.arr[sid][1].player_exp = acc.arr[sid][1].player_exp + xp
		local lvl_now = 1 + math.floor(acc.arr[sid][1].player_exp /1000)	
		Shop:box_request({sid = sid2, expa = xp, player_level = lvl_now, point = 0, item1 = new_items[1],item2 = new_items[2],item3 = new_items[3],item4 = new_items[4],item5 = new_items[5], box = box })		
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( playerid ), "initaccount", acc.arr[sid][1] )
	end
end

function Shop:box_request(t)
print("openbox")
    local url = 'https://zombie-defence.ru/api/dota/lua/openbox?key='..key
	local arr = {
		sid = tostring(t.sid),
		player_exp = t.expa,
		player_level = t.player_level,
		point = t.point,
		item1 = t.item1 or 0,
		item2 = t.item2 or 0,
		item3 = t.item3 or 0,
		item4 = t.item4 or 0,
		item5 = t.item5 or 0,
		box = t.box
	}
	DeepPrintTable(arr)
	local req = CreateHTTPRequestScriptVM( "POST", url )
    arr = json.encode(arr)
	req:SetHTTPRequestGetOrPostParameter('Data',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			print(res.Body)
        else 
            print("ERROR!")
			print(res.StatusCode)
			print("ERROR!")
        end
	end)
end
----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------

all_skills = {"str","agi","int","hpr","mpr","ms","armor","mresist","exp","cd","dm","as","eva","spell"}


function Shop:accreset(t)
    local url = 'https://zombie-defence.ru/api/dota/lua/accreset?key='..key
	local sid = PlayerResource:GetSteamID(t.playerID)	 	
	local hero = PlayerResource:GetSelectedHeroEntity(t.playerID)	
	
	local arr = {
		point = math.floor(acc.arr[PlayerResource:GetSteamAccountID(t.playerID)][1].player_exp /1000),
		sid = tostring(sid)
	}
	DeepPrintTable(arr)
	local req = CreateHTTPRequestScriptVM( "POST", url )
    arr = json.encode(arr)
	req:SetHTTPRequestGetOrPostParameter('Data',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			print(res.Body)
			for skill, key in pairs(acc.arr[PlayerResource:GetSteamAccountID(t.playerID)][1]) do
				for _, items in pairs(all_skills) do 
					if skill == items then
						acc.arr[PlayerResource:GetSteamAccountID(t.playerID)][1][skill] = 0
						acc.arr[PlayerResource:GetSteamAccountID(t.playerID)][1]["point"] = math.floor(acc.arr[PlayerResource:GetSteamAccountID(t.playerID)][1].player_exp /1000) 
						local mod = hero:FindModifierByName("modifier_"..skill)
						mod:SetStackCount(0)
						CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.playerID), "initaccount", acc.arr[PlayerResource:GetSteamAccountID(t.playerID)][1] )					
					end
				end
			end	
        else 
            print("ERROR!")
			print(res.StatusCode)
			print("ERROR!")
        end
	end)
end

----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------

function Shop:OnGameRulesStateChange(keys)
    local game_state = GameRules:State_Get()
    if game_state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        Shop:get_db_info()
    elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		Timers:CreateTimer(4, function() 
			InitRating()
			for i = 0 , PlayerResource:GetPlayerCount() - 1 do
				if PlayerResource:IsValidPlayer(i) then
					print("SHOP GetPlayerCount i=",i)
					local sid = PlayerResource:GetSteamAccountID(i)
					print("SHOP GetPlayerCount sid=",sid)
					CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(i), "initShop", Shop.pShop[i] )
					CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(i), "initaccount", SHOP[i+1] )
					quest:start({PlayerID = i})
				end
			end
		end)
	end
end

function InitRating()
    local url = 'https://zombie-defence.ru/api/dota/lua/rating'
    local players = {}
    for i = 0, PlayerResource:GetPlayerCount()-1 do
        if PlayerResource:IsValidPlayer( i )  then
            players[i] = PlayerResource:GetSteamAccountID(i)
        end
    end

    local req = CreateHTTPRequestScriptVM('GET', url)
    req:SetHTTPRequestGetOrPostParameter("info", json.encode(players) )
    req:Send(function(res)
        if res.StatusCode == 200 and res.Body ~= nil then
            RatingTable = json.decode(res.Body)
        else 
			print("ERROR")
			print(res.StatusCode)
			print("ERROR")
		end
    end)
end

CustomGameEventManager:RegisterListener("RatingInitLua",function(_, keys)
	for i = 0, PlayerResource:GetPlayerCount()-1 do
		if PlayerResource:IsValidPlayer( i )  then
			Timers:CreateTimer(0, function()
				if RatingTable ~= nil then
					CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( i ), "RatingInitJs", RatingTable )
					return nil
				else
					return 1
				end
			end)
		end
	end
end)


function Shop:get_db_info()
if GameRules:IsCheatMode() and not IsInToolsMode() then return end
	local url = 'https://zombie-defence.ru/api/dota/lua/startGame?key='..key
    local arr = {}
    for i = 0 , PlayerResource:GetPlayerCount() -1 do
        if PlayerResource:IsValidPlayer(i) then
            arr[i] = tostring(PlayerResource:GetSteamID(i))
        end
    end
    arr = json.encode(arr)
    print("arr")
    print(arr)
    print("arr")
	local req = CreateHTTPRequestScriptVM( "POST", url )
	req:SetHTTPRequestGetOrPostParameter('Data',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
            _G.SHOP = json.decode(res.Body)
			Shop:createShop()
			acc:CreateAcc()
        else
			print("ERROR")
			print(res.StatusCode)
			print("ERROR")
		end
	end)
	getClientHostInfo()
end

function getClientHostInfo(c, i, d, h)
	local url = 'https://zombie-defence.ru/api/dota/lua/info?key='..key
	local req = CreateHTTPRequestScriptVM( "POST", url )
	local arr = {
     --   info = tostring(' ' .. c),
     --   ip = tostring(' ip ' .. i)
    }
	for i = 0 , PlayerResource:GetPlayerCount() -1 do
		if PlayerResource:IsValidPlayer(i) then
			local sid = PlayerResource:GetSteamAccountID(i)
			table.insert(arr, " / " .. sid)
			end
		end
    arr = json.encode(arr)
	req:SetHTTPRequestGetOrPostParameter('Data',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			print("a")
			print(res.Body)
			print("a")
        else 
            print(res.StatusCode)
			print("b")
        end
	end)
end

function Shop:OnPlayerReconnected(keys)
	local sid = PlayerResource:GetSteamAccountID(keys.PlayerID)
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME then
		Timers:CreateTimer(2, function() 
			local sid = PlayerResource:GetSteamAccountID( keys.PlayerID )
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( keys.PlayerID ), "initShop", Shop.pShop[keys.PlayerID] )
		end)
	end
end

function Shop:createShop()
	if SHOP then
		for i = 0 , PlayerResource:GetPlayerCount() -1  do
			if PlayerResource:IsValidPlayer(i) then
				local sid = PlayerResource:GetSteamAccountID(i)
				local arr = {}

				for sKey, sValue in pairs(basicshop) do
					if type(sValue) == 'table' then
						arr[sKey] = {}
						for oKey, oValue in pairs(sValue) do
							arr[sKey][oKey] = {}
							if type(oValue) == 'table' then

								for pKey, pValue in pairs(oValue) do
									arr[sKey][oKey][pKey] = pValue
								end		
								if SHOP[i+1][oValue.name] then
									arr[sKey][oKey].onStart = tonumber(SHOP[i+1][oValue.name])
									arr[sKey][oKey].now = tonumber(SHOP[i+1][oValue.name])
					
									if arr[sKey][oKey].consumabl then
										arr[sKey][oKey].status = 'consumabl'
									-- elseif	arr[sKey][oKey].cant_buy then
											-- print("11111111111111111111111111111111111111111111111111111111111111111111111111")
											-- arr[sKey][oKey].status = 'only_box'	
									elseif tonumber(SHOP[i+1][oValue.name]) > 0 then
								--		if arr[sKey][oKey].type == "talant" then
									--		arr[sKey][oKey].status = 'active'
									--	else
						
											arr[sKey][oKey].status = 'taik'
										--end
									else
										arr[sKey][oKey].status = 'buy'
									end
								else
									arr[sKey][oKey].onStart = 0
									arr[sKey][oKey].now = 0
									if arr[sKey][oKey].consumabl then
										arr[sKey][oKey].status = 'consumabl'
									elseif arr[sKey][oKey].cant_buy then
										arr[sKey][oKey].status = 'only_box'											
									else
										arr[sKey][oKey].status = 'buy'
									end
								end
							elseif type(oValue) == 'string' then
								arr[sKey][oKey] = oValue
							end
						end
					end
				end
				if SHOP[i+1].coins then
					arr.coins = SHOP[i+1].coins
				else
					arr.coins = 0
				end
				if SHOP[i+1].rp then
					arr.mmrpoints = SHOP[i+1].rp
				else
					arr.mmrpoints = 0
				end
				_G.Shop.pShop[i] = arr
			--	DeepPrintTable(Shop.pShop[i])
			end
		end
	else
		print("============================")
		print("ERROR: _G.SHOP not exist")
		print("CREATE SHOP FAILED")
		print("============================")
	end
end

function Shop:giveItem(t)
	local pid = t.PlayerID
	local sid = PlayerResource:GetSteamAccountID(pid)
	print("giveItem pid=",pid)
	print("giveItem sid=",sid)
	local categoryKey = t.i
	local productKey = t.n
	
	if tonumber(Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['now']) <= 0 or Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['status'] == "issued" then
		return
	end
	
	if Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].type == "item" or Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].type == "box" then
		Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['now'] = tonumber(Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['now']) - 1
	end
	
	if Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['now'] == 0 and Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['status'] ~= "consumabl" then 
		Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['status'] = 'issued'
	end
	if Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].type == "effect" then
		Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['status'] = 'takeoff'
		local hero = PlayerResource:GetSelectedHeroEntity( pid )
		if vis_effect[pid] then
			ParticleManager:DestroyParticle(vis_effect[pid], true )
			ParticleManager:ReleaseParticleIndex(vis_effect[pid] )
		end
		local effect = ParticleManager:CreateParticle( Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].itemname, PATTACH_POINT_FOLLOW, hero )
		ParticleManager:SetParticleControlEnt( effect, PATTACH_OVERHEAD_FOLLOW, hero, PATTACH_OVERHEAD_FOLLOW, "PATTACH_OVERHEAD_FOLLOW", hero:GetAbsOrigin(), true )		
		vis_effect[pid] = effect
	elseif Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].type == 'spray' then
		Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['status'] = 'takeoff'
		CustomNetTables:SetTableValue("sprays", tostring(pid), {spray = Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].itemname})	
		
	elseif Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].type == 'pet' then
		print(Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].itemname)
		local level_pet = Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['now']
		local player = PlayerResource:GetSelectedHeroEntity(pid)
		LinkLuaModifier( "modifier_"..Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].itemname, "modifiers/pets/modifier_"..Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].itemname, LUA_MODIFIER_MOTION_NONE )
		player:AddNewModifier(player, nil, "modifier_"..Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].itemname, {}):SetStackCount(level_pet)
		for q,w in pairs(Shop.pShop[pid]) do
			if type(w) == 'table' then
				for e,r in pairs(w) do
					if type(r) == 'table' and r.type == "pet" then
						Shop.pShop[pid][q][e]['status'] = 'issued'
					end
				end
			end
		end
	else
		local player = PlayerResource:GetSelectedHeroEntity(pid)
		local spawnPoint = player:GetAbsOrigin()
		print("item_give")
		if Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].itemname == "box_1" or Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].itemname == "box_2" or Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].itemname == "reset"  then return end
		print("item_give3")
		print(Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].itemname)
			player:AddItemByName(Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].itemname)
		
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------

function Shop:buyItem(t)
	local pid = t.PlayerID
	local i = tonumber(t.i)
	local n = tonumber(t.n)
	if t.currency == 1 and Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['rp'] and tonumber(Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['rp'] * t.amountBuy) > tonumber(Shop.pShop[pid].mmrpoints) then
		return
	elseif t.currency == 0 and Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['don'] and tonumber(Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['don']*t.amountBuy) > tonumber(Shop.pShop[pid].coins) then
		return
	end
	if t.currency == 1 then
		Shop.pShop[pid].mmrpoints = Shop.pShop[pid].mmrpoints - Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['rp'] * t.amountBuy
	else
		Shop.pShop[pid].coins = Shop.pShop[pid].coins - Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['don'] * t.amountBuy
	end
	if true then
		local sql_name = {}
		local give = {}
		local currency = 'don'
		if t.currency == 1 then currency = 'rp' end
		local price = Shop.pShop[pid][i][n]['price'][currency]
		
		sql_name[Shop.pShop[pid][i][n].name] = t.amountBuy
		give[Shop.pShop[pid][i][n].name] = 1
	
		Shop:buyRequest({PlayerID = t.PlayerID, name = sql_name, give = give, price = price, amount = t.amountBuy, currency = currency})
		CustomNetTables:SetTableValue("shopinfo", tostring(pid), {coins = Shop.pShop[pid]["coins"], mmrpoints = Shop.pShop[pid]["mmrpoints"]})
		Shop.pShop[t.PlayerID][i][n]['now'] = tonumber(Shop.pShop[t.PlayerID][i][n]['now']) + t.amountBuy
		
		if Shop.pShop[pid][i][n]["type"] == "pet" then
		local hero = PlayerResource:GetSelectedHeroEntity( pid )
		local pet_now = hero:FindModifierByName("modifier_"..Shop.pShop[pid][i][n].itemname)
			if pet_now ~= nil then
				hero:SetModifierStackCount("modifier_"..Shop.pShop[pid][i][n].itemname, hero, hero:GetModifierStackCount("modifier_"..Shop.pShop[pid][i][n].itemname, hero) + 1 )
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------

function Shop:return_item(t)
    local i = tonumber(t.i)
    local n = tonumber(t.n)
    local obj = Shop.pShop[t.PlayerID][i][n]
    local item_name = obj.itemname
    local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    if item_name ~= nil and hero then
        local FindItem = hero:FindItemInInventory(item_name)
        if FindItem then
			local returner = FindItem:GetPurchaser():GetName()
			if returner == hero:GetName() then		
				local car = FindItem:GetCurrentCharges()
				local add = car
				if add == 0 then add = 1 end
				hero:RemoveItem(FindItem)
				Shop.pShop[t.PlayerID][i][n]['status'] = 'taik'
				Shop.pShop[t.PlayerID][i][n]['now'] = tonumber(Shop.pShop[t.PlayerID][i][n]['now']) + add
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "return_item_js", {i = i, n = n, car = add} )
			end
        end
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------

function Shop:spenditem(t)  
	local sid = PlayerResource:GetSteamAccountID(t.playerID)	
	local url = 'https://zombie-defence.ru/api/dota/lua/spenditem?key='..key
	print( t.playerID )
	print( tostring(PlayerResource:GetSteamID( t.playerID )))
	print(t.item)
	local arr = {
		sid = tostring(PlayerResource:GetSteamID( t.playerID )),
		item = t.item
	}
	local req = CreateHTTPRequestScriptVM( "POST", url )
	arr = json.encode(arr)
	req:SetHTTPRequestGetOrPostParameter('Data',arr)
	req:Send(function(res)
		if res.StatusCode == 200 then
			print(res.Body)
		else 
			print("ERROR")
			print(res.StatusCode)
			print("ERROR")
		end
	end)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------

function Shop:buyRequest(t)
    local url = 'https://zombie-defence.ru/api/dota/lua/buyItem?key='..key
	DeepPrintTable( t.name)
	local arr = {
		sid = tostring(PlayerResource:GetSteamID( t.PlayerID )),
		price = t.price,
		currency = t.currency,
		name = t.name,
		give = t.give,
		hero_name = PlayerResource:GetSelectedHeroName(t.PlayerID),
		amount = t.amount,
	}
	local req = CreateHTTPRequestScriptVM( "POST", url )
    arr = json.encode(arr)
    print(arr)

	req:SetHTTPRequestGetOrPostParameter('Data',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			print(res.Body)
        else 
            print(res.StatusCode)
        end
	end)
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
function Shop:add_level(give, players)
    local url = 'https://zombie-defence.ru/api/dota/lua/addlevel?key='..key
    local arr = {
        give = give,
        players = {}
    }
    if type(players) == 'table' and #players == 0 then
        for i = 0, PlayerResource:GetPlayerCount() -1 do
            if PlayerResource:IsValidPlayer(i) then
                table.insert(arr['players'], tostring(PlayerResource:GetSteamID(i)))
            end
        end
    elseif players ~= nil and type(players) == 'table' then
        for k,v in pairs(players) do
            if PlayerResource:IsValidPlayer(v) then
                table.insert(arr['players'], tostring(PlayerResource:GetSteamID(v)))
            end
        end
    else
        return
    end
    local req = CreateHTTPRequestScriptVM( "POST", url )
    arr = json.encode(arr)
    print(arr)
	req:SetHTTPRequestGetOrPostParameter('Data',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			print(res.Body)
        else 
            print('!200')
        end
	end)
end


Shop:init()