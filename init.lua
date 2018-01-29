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


-- register builder tools
local mod_3d_armor = minetest.get_modpath("3d_armor")
-- if yes - dofile
if mod_3d_armor then
	dofile(THIS_MOD_PATH.."/register_builder_tools.lua");
	minetest.log("action", "[MOD]"..THIS_MOD.." -- 3d Armor installed, register builder tools/armor.")
end



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
		if not builder.is_builder(player_name) then
			minetest.chat_send_player(player_name,
					"This button has been disabled because you don't have the builder privileg!")
			-- unified_inventory.set_inventory_formspec(player, unified_inventory.current_page[player_name])
			return
		end
		player:get_inventory():set_list("main", {})
		minetest.chat_send_player(player_name, "Change to builder inventory")
	end,
	condition = function(player)
		return builder.is_builder(player:get_player_name())
	end,
})

-- what happen if player uses button
minetest.register_on_player_receive_fields(function(player, formname, fields)
	local player_name = player:get_player_name()
	if fields.builder then --main page
		--worldedit.show_page(name, "builer")
		minetest.chat_send_player(player_name, "Change to builder inventory")
		return true
	elseif fields.builder_exit then --return to original page
		local player = minetest.get_player_by_name(name)
		if player then
			unified_inventory.set_inventory_formspec(player, "craft")
		end
		return true
	end
	return false
end)

-- aus worldedit
builder.pages = {} --mapping of identifiers to options
local identifiers = {} --ordered list of identifiers
builder.register_gui_function = function(identifier, options)
	if options.privs == nil or next(options.privs) == nil then
		error("privs unset")
	end
	builder.pages[identifier] = options
	table.insert(identifiers, identifier)
end

builder.register_gui_function("builder_gui", {
	name = "Builder GUI",
	privs = {interact=true},
	get_formspec = function(name)
		--create a form with all the buttons arranged in a grid
		local buttons, x, y, index = {}, 0, 1, 0
		local width, height = 3, 0.8
		local columns = 5
		for i, identifier in pairs(identifiers) do
			if identifier ~= "builder_gui" then
				local entry = worldedit.pages[identifier]
				table.insert(buttons, string.format((entry.get_formspec and "button" or "button_exit") ..
					"[%g,%g;%g,%g;%s;%s]", x, y, width, height, identifier, minetest.formspec_escape(entry.name)))

				index, x = index + 1, x + width
				if index == columns then --row is full
					x, y = 0, y + height
					index = 0
				end
			end
		end
		if index == 0 then --empty row
			y = y - height
		end
		return string.format("size[%g,%g]", math.max(columns * width, 5), math.max(y + 0.5, 3)) ..
			"button[0,0;2,0.5;builder_gui_exit;Back]" ..
			"label[2,0;Builder GUI]" ..
			table.concat(buttons)
	end,
})

-- chatcommand 
-- builder make_list 
minetest.register_chatcommand("builder", {
	description = "modifie the allowed items for buildes. \n builder make_list creats a list of all installed items. copy this list into the mod path to use.",
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

-- from ui
--apply filter to the inventory list (create filtered copy of full one)
function builder.apply_filter(player, filter, search_dir)
	if not player then
		return false
	end
	local player_name = player:get_player_name()
	local lfilter = string.lower(filter)
	local ffilter
	if lfilter:sub(1, 6) == "group:" then
		local groups = lfilter:sub(7):split(",")
		ffilter = function(name, def)
			for _, group in ipairs(groups) do
				if not def.groups[group]
				or def.groups[group] <= 0 then
					return false
				end
			end
			return true
		end
	else
		ffilter = function(name, def)
			local lname = string.lower(name)
			local ldesc = string.lower(def.description)
			return string.find(lname, lfilter, 1, true) or string.find(ldesc, lfilter, 1, true)
		end
	end
	local is_creative = unified_inventory.is_creative(player_name)
	unified_inventory.filtered_items_list[player_name]={}
	for name, def in pairs(minetest.registered_items) do
		if (not def.groups.not_in_creative_inventory
			or def.groups.not_in_creative_inventory == 0)
		and def.description
		and def.description ~= ""
		and ffilter(name, def)
		and (is_creative or unified_inventory.crafts_for.recipe[def.name]) then
			table.insert(unified_inventory.filtered_items_list[player_name], name)
		end
	end
	table.sort(unified_inventory.filtered_items_list[player_name])
	unified_inventory.filtered_items_list_size[player_name] = #unified_inventory.filtered_items_list[player_name]
	unified_inventory.current_index[player_name] = 1
	unified_inventory.activefilter[player_name] = filter
	unified_inventory.active_search_direction[player_name] = search_dir
	unified_inventory.set_inventory_formspec(player,
	unified_inventory.current_page[player_name])
end

-- --end from ui



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



