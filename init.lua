--[[


	
Copyright (c) 2018
	ralf Weinert <downad@freenet.de>
Source Code: 	
	https://github.com/downad/aftools
License: GPLv2.1

]]--


-- ModName
local THIS_MOD = minetest.get_current_modname()
-- ModPath
local THIS_MOD_PATH = minetest.get_modpath(THIS_MOD)

-- define a new privileg
-- a builder can use the creative-menu, but the admin can restict items 
minetest.register_privilege("builder", "Player can get items like being creative.")
minetest.register_privilege("builder_admin", "The admin can create the list.")

-- register the button
unified_inventory.register_button("builder", {
	type = "image",
	image = "builder_button.png",
	tooltip = "Builder Grid",
	action = function(player)
		local player_name = player:get_player_name()
		minetest.chat_send_player(player_name, "hello "..player_name.." you are builder: "..tostring(unified_inventory.is_builder(player_name)))
		if not is_builder(player_name) then
			minetest.chat_send_player(player_name,
					"This button has been disabled because you don't have the builder privileg!")
			-- unified_inventory.set_inventory_formspec(player, unified_inventory.current_page[player_name])
			return
		end
		player:get_inventory():set_list("main", {})
		minetest.chat_send_player(player_name, "Change to builder inventory")
	end,
	condition = function(player)
		return is_builder(player:get_player_name())
	end,
})

-- what happesn if player uses button
minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name = player:get_player_name()
	if fields.worldedit_gui then --main page
		worldedit.show_page(name, "worldedit_gui")
		return true
	elseif fields.worldedit_gui_exit then --return to original page
		local player = minetest.get_player_by_name(name)
		if player then
			unified_inventory.set_inventory_formspec(player, "craft")
		end
		return true
	end
	return false
end)



-- create a list of all items in the game
local items_list = {}
local file_name_for_item_list = "all_items_in_game.txt" -- filename in path .get_worldpath().."/players/ 
for name, def in pairs(minetest.registered_items) do
	if (not def.groups.not_in_creative_inventory or
		 def.groups.not_in_creative_inventory == 0) and
		 def.description and def.description ~= "" then
		table.insert(items_list, name)
	end
end
table.sort(items_list)
local file = io.open(minetest.get_worldpath().."/players/"..file_name_for_item_list, "w")
if file then
	for ii, item_name in ipairs(items_list) do
		-- file:write(minetest.serialize(ItemName))
		file:write(item_name.."\n")
	end      
  file:close()
end



-- log that the mod is loades 
minetest.log("action", "[MOD]"..THIS_MOD.." -- loaded!")
	
	
	-- function print_log to print a info on the screen
function print_log(printstring, withIntro)
	if withIntro > 0 then
		print("[MOD]"..THIS_MOD)
	end
	print("     "..printstring)
end

-- new privilege builder
function is_builder(playername)
	return minetest.check_player_privs(playername, {builder=true})
end

-- read list and return can_get_this_item = true or false
function player_can_get_this_item(item_by_name)
	print("Unified Inventory. player_can_get_this_item: "..item_by_name)
	return true
end



