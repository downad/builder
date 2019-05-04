
-- define a new privileg
-- a builder can use the creative-menu, but the admin can restict items 
minetest.register_privilege("builder", "Player can get allowed items like being creative.")
minetest.register_privilege("builder_admin", "The admin can create the allowed_item_list.")

-- chatcommand 
-- builder make_list 
minetest.register_chatcommand("builder", {
	description = "Builder chat-commands. \n 'builder make_list' creats a list of all installed items. Modifie this list an rename it to 'allowed_items_for_builder.txt' in the world/players-path.",
	params = "<make_list> <no_tools> <no_armor> <no_mats> ",
	privs = "builder_admin",
	func = function(name, param)
		-- the make_list command can have args <no_tools> <no_armor> <no_mats> <no_nogroup> <strict>
		local value = string.split(param, " ") 
		local command = value[1]
		-- if args are set 
		local no_tools = false
		local no_armor = false
		local no_mats = false
		local no_nogoup = false
		if value[2] ~= nil then
			if value[2] == "strict" then
				no_tools = true
				no_armor = true
				no_mats = true
				no_nogroup = true
			else
				for k,v in ipairs(value) do
					if v == "no_tools" then
						no_tools = true
					elseif v == "no_armor" then
						no_armor = true
					elseif v == "no_mats" then
						no_mats = true
					elseif v == "no_nogroup" then
						no_nogroup = true
					end
				end
			end
		end
		-- is the item allowed? 
		local allowed = true
				
		if command == "make_list" then
			minetest.chat_send_player(name, "Creating a list for the items!")
			-- create a list of all items in the game
			local items_list = {}
			--local file_name_for_item_list = "all_items_in_game.txt" -- filename in path .get_worldpath().."/players/ 
			for name, def in pairs(minetest.registered_items) do
				if (not def.groups.not_in_creative_inventory or
					 def.groups.not_in_creative_inventory == 0) and
					 def.description and def.description ~= "" then
					table.insert(items_list, name)
				end
			end
			table.sort(items_list)
			local file = io.open(builder.filename, "w")
			--local file = io.open(minetest.get_worldpath().."/"..file_name_for_item_list, "w")
			if file then
				for ii, item_name in ipairs(items_list) do
					allowed = builder:is_allowed(item_name, no_tools, no_armor, no_mats)
					file:write(item_name.." = "..tostring(allowed).."\n")
				end      
				file:close()
			end
			builder.allowed_items = { }
			builder:load_allowed_items()
		elseif param ~= "" then
			minetest.chat_send_player(name, "Invalid usage.  Type \"/help builder\" for more information.")
		end
	end
})



