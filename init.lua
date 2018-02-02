--[[


	
Copyright (c) 2018
	ralf Weinert <downad@freenet.de>
Source Code: 	
	https://github.com/downad/aftools
License: GPLv2.1

]]--

-- a variable to put all in
builder = {}

-- ModName
local THIS_MOD = minetest.get_current_modname()
-- ModPath
local THIS_MOD_PATH = minetest.get_modpath(THIS_MOD)


-- register builder armor
local mod_3d_armor = minetest.get_modpath("3d_armor")
-- if yes - dofile
if mod_3d_armor then
	dofile(THIS_MOD_PATH.."/register_builder_3d_armor.lua")
	minetest.log("action", "[MOD]"..THIS_MOD.." -- 3d Armor installed, register builder tools/armor.")
end
-- register builder tools
dofile(THIS_MOD_PATH.."/register_builder_tools.lua")

-- define new privilegs and commands 
dofile(THIS_MOD_PATH.."/register_privs_and_commands.lua") 

-- override ui_functions
dofile(THIS_MOD_PATH.."/override_ui.lua") 


-- log that the mod is loades 
minetest.log("action", "[MOD]"..THIS_MOD.." -- loaded!")
	
	
	-- function print_log to print a info on the screen
function builder.print_log(printstring, withIntro)
	if withIntro > 0 then
		print("[MOD]"..THIS_MOD)
	end
	print("     "..printstring)
end

-- is player a builder?
function builder.is_builder(playername)
	return minetest.check_player_privs(playername, {builder=true})
end

-- read list and return can_get_this_item = true or false
function builder.player_can_get_this_item(item_by_name)
	print("Unified Inventory. player_can_get_this_item: "..item_by_name)
	return true
end




