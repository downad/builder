
-- define a new privileg
-- a builder can use the creative-menu, but the admin can restict items 
minetest.register_privilege("builder", "Player can get allowed items like being creative.")
minetest.register_privilege("builder_admin", "The admin can create the allowed_item_list.")

-- chatcommand 
-- builder make_list 
minetest.register_chatcommand("builder", {
	description = "Builder chat-commands. \n 'builder make_list' creats a list of all installed items. Modifie this list an rename it to 'allowed_items_for_builder.txt' in the world/players-path.",
	params = "<make_list> ",
	privs = "builder_admin",
	func = function(name, param)
		local pos = vector.round(minetest.get_player_by_name(name):getpos())
		if param == "make_list" then
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
					file:write(item_name.."\n")
				end      
				file:close()
			end
		elseif param ~= "" then
			minetest.chat_send_player(name, "Invalid usage.  Type \"/help builder\" for more information.")
		end
	end
})
