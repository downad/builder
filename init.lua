--[[


	
Copyright (c) 2018
	ralf Weinert <downad@freenet.de>
Source Code: 	
	https://github.com/downad/aftools
License: GPLv2.1

]]--

-- a variable to put all in
builder = {}

-- Modname
local THIS_MOD = minetest.get_current_modname()
-- Mod_Path
local THIS_MOD_PATH = minetest.get_modpath(THIS_MOD)

-- 0 = don't print modname
-- 1 = print modname
builder.PRINT_MODNAME_YES = 0  
builder.PRINT_MODNAME_NO = 1  



-- register builder tools
dofile(THIS_MOD_PATH.."/register_builder_tools.lua")

-- register builder armor if 3d armor is present
local mod_3d_armor_present = minetest.get_modpath("3d_armor")
if mod_3d_armor_present then
	dofile(THIS_MOD_PATH.."/register_builder_3d_armor.lua")
	minetest.log("action", "[MOD]"..THIS_MOD.." -- 3d Armor installed, register builder tools/armor.")
end



-- define new privilegs and commands 
dofile(THIS_MOD_PATH.."/register_privs_and_commands.lua") 

-- override ui_functions
dofile(THIS_MOD_PATH.."/override_ui.lua") 


-- create a table with the allowed items
builder.allowed_items = {}
-- local filename = THIS_MOD_PATH.."/players/allowed_items_for_builder.txt"
local filename = minetest.get_worldpath().."/players/allowed_items_for_builder.txt"
-- read file allowed_items_for_builder.txt in an table
for line in io.lines(filename) do 
	--builder.print_log("Allowed Item read: "..line, builder.PRINT_MODNAME_NO)
	print("Allowed Item read: "..line)
	table.insert (builder.allowed_items, line);
end



-- log that the mod is loades 
minetest.log("action", "[MOD]"..THIS_MOD.." -- loaded!")
	
	
	
	
-- functions 
-- print_log to print a info on the screen with_modname	
function builder.print_log(print_string, with_modname)
	if with_modname > 0 then
		print("[MOD]"..THIS_MOD)
	end
	print("     "..print_string)
end




-- has player builder privileg?
function builder.is_builder(playername)
	return minetest.check_player_privs(playername, {builder=true})
end

-- read list and return can_get_this_item = true or false
function builder.player_can_get_this_item(item_by_name)
	local item_allowed = false
	for key,line in pairs(builder.allowed_items) do
		-- print("line: "..line.." - searchitem: "..item_by_name)
		-- for the exact search the name must be mask
		-- if 'default:mese' is not allowed the 'default:meselamp' will allow the 'default:mese' 
		local test_line = line.."#"
		local test_item_by_name = item_by_name.."#"
		-- is the block / item allowed?		
		if string.find(test_line, test_item_by_name, 1, true) then
			item_allowed =  true
			-- builder.print_log("builder: player can get this block/item: "..item_by_name,builder.PRINT_MODNAME_NO)
		end
	end
	builder.print_log("builder: player can get this block/item: "..item_by_name.." yes/no "..tostring(item_allowed),builder.PRINT_MODNAME_YES)
	return item_allowed
end




