--[[


	
Copyright (c) 2018
	ralf Weinert <downad@freenet.de>
Source Code: 	
	https://github.com/downad/aftools
License: GPLv2.1

]]--

-- a variable to put all in
builder = {
	-- some tables for not allowed things
	mats = { "_lava", "_lump", "_ingot", "stone_with_", "lava_", 
		"diamondblock", "default:diamond", 
		"goldblock", "brass_block", "copperblock", "copperpatina", 
		"default:mese",  
		"steelblock", 
		"mineral_mithril", "mithril_block", "tinblock", 
	},
	tools = { "pick_", "axe_", "shovel_", "hoe_", "sword_", "scythe_mithril", "_weapons", 
	},
	armor = { "boots_", "chestplate_", "helmet_", "leggings_", "shield_",
	},
	nogroup = { "dmobs:", "travelnet:", "mobs_animal:", "tnt:" 
	},
	-- create a table with the allowed items
	allowed_items = { },
	-- "builder:axe_diamond", "builder:boots_builder", "builder:chestplate_builder", "builder:helmet_builder", "builder:leggings_builder",
	--	"builder:pick_diamond", "builder:shovel_diamond",
	
	-- 0 = don't print modname
	-- 1 = print modname
	PRINT_MODNAME_YES = 0, 
	PRINT_MODNAME_NO = 1,  
}

-- Modname
builder.THIS_MOD = minetest.get_current_modname()
-- Mod_Path
builder.THIS_MOD_PATH = minetest.get_modpath(builder.THIS_MOD)

-- filename for the allowed items in game
builder.filename = minetest.get_worldpath().."/allowed_items_for_builder.txt"
--builder.filename = minetest.get_worldpath().."/all_items_in_game.txt"
-- filename for logfile - player uses builder
builder.logfile =  minetest.get_worldpath().."/builder.log"

-- register builder tools
dofile(builder.THIS_MOD_PATH.."/register_builder_tools.lua")

-- register builder armor if 3d armor is present
local mod_3d_armor_present = minetest.get_modpath("3d_armor")
if mod_3d_armor_present then
	dofile(builder.THIS_MOD_PATH.."/register_builder_3d_armor.lua")
	minetest.log("action", "[MOD]"..builder.THIS_MOD.." -- 3d Armor installed, register builder tools/armor.")
end



-- define new privilegs and commands 
dofile(builder.THIS_MOD_PATH.."/register_privs_and_commands.lua") 

-- override ui_functions
dofile(builder.THIS_MOD_PATH.."/override_ui.lua") 

-- builder_functions
dofile(builder.THIS_MOD_PATH.."/func.lua") 

builder:load_allowed_items()

-- log that the mod is loades 
minetest.log("action", "[MOD]"..builder.THIS_MOD.." -- loaded!")
	
	
	


