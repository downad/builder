-- builder mod by Downad 
-- override this function 
-- ask for builder privileg to give item
minetest.register_on_player_receive_fields(function(player, formname, fields)
	local player_name = player:get_player_name()

	local ui_peruser,draw_lite_mode = unified_inventory.get_per_player_formspec(player_name)

	if formname ~= "" then
		return
	end

	-- always take new search text, even if not searching on it yet
	if fields.searchbox
	and fields.searchbox ~= unified_inventory.current_searchbox[player_name] then
		unified_inventory.current_searchbox[player_name] = fields.searchbox
		unified_inventory.set_inventory_formspec(player, unified_inventory.current_page[player_name])
	end

	for i, def in pairs(unified_inventory.buttons) do
		if fields[def.name] then
			def.action(player)
			minetest.sound_play("click",
					{to_player=player_name, gain = 0.1})
			return
		end
	end

	-- Inventory page controls
	local start = math.floor(
		unified_inventory.current_index[player_name] / ui_peruser.items_per_page + 1)
	local start_i = start
	local pagemax = math.floor(
		(#unified_inventory.filtered_items_list[player_name] - 1)
		/ (ui_peruser.items_per_page) + 1)

	if fields.start_list then
		start_i = 1
	end
	if fields.rewind1 then
		start_i = start_i - 1
	end
	if fields.forward1 then
		start_i = start_i + 1
	end
	if fields.rewind3 then
		start_i = start_i - 3
	end
	if fields.forward3 then
		start_i = start_i + 3
	end
	if fields.end_list then
		start_i = pagemax
	end
	if start_i < 1 then
		start_i = 1
	end
	if start_i > pagemax then
		start_i = pagemax
	end
	if start_i ~= start then
		minetest.sound_play("paperflip1",
				{to_player=player_name, gain = 1.0})
		unified_inventory.current_index[player_name] = (start_i - 1) * ui_peruser.items_per_page + 1
		unified_inventory.set_inventory_formspec(player,
				unified_inventory.current_page[player_name])
	end

	local clicked_item
	for name, value in pairs(fields) do
		if string.sub(name, 1, 12) == "item_button_" then
			local new_dir, mangled_item = string.match(name, "^item_button_([a-z]+)_(.*)$")
			clicked_item = unified_inventory.demangle_for_formspec(mangled_item)
			if string.sub(clicked_item, 1, 6) == "group:" then
				minetest.sound_play("click", {to_player=player_name, gain = 0.1})
				unified_inventory.apply_filter(player, clicked_item, new_dir)
				unified_inventory.current_searchbox[player_name] = clicked_item
				unified_inventory.set_inventory_formspec(player,
					unified_inventory.current_page[player_name])
				return
			end
			if new_dir == "recipe"
			or new_dir == "usage" then
				unified_inventory.current_craft_direction[player_name] = new_dir
			end
			break
		end
	end
	if clicked_item then
		minetest.sound_play("click",
				{to_player=player_name, gain = 0.1})
		local page = unified_inventory.current_page[player_name]
		local player_creative = unified_inventory.is_creative(player_name)
		page = "craftguide"
		if player_creative then 
			page = "creative_yes"
		end
		
		-- builder mod override by downad 
		-- check builder privileg
		-- if minetest.check_player_privs(player_name, {builder=true}) then
		if  builder.is_builder(player_name) then
			page = "builder_yes"
		end
		-- end builder mod override 
		
		-- not creative / creative World or builder privileges
		if page == "craftguide" then
			unified_inventory.current_item[player_name] = clicked_item
			unified_inventory.alternate[player_name] = 1
			unified_inventory.set_inventory_formspec(player, "craftguide")
		elseif player_creative then
			local inv = player:get_inventory()
			local stack = ItemStack(clicked_item)
			stack:set_count(stack:get_stack_max())
			if inv:room_for_item("main", stack) then
				inv:add_item("main", stack)
			end
		-- builder mod override by downad 
		elseif builder.is_builder(player_name)  then 
			local inv = player:get_inventory()
			local stack = ItemStack(clicked_item)
			if inv:room_for_item("main", stack) then
				-- is this item allowed?
				local item_by_name = stack:get_name()
				if builder.player_can_get_this_item(item_by_name) then
					stack:set_count(stack:get_stack_max())
					inv:add_item("main", stack)
				else
					minetest.chat_send_player( player_name, "Builder-Mod: "..player_name..", this block/item ("..item_by_name..") is not allowed to get.");
				end
			end
			-- end builder mod override 
		end
	end

	if fields.searchbutton
			or fields.key_enter_field == "searchbox" then
		unified_inventory.apply_filter(player, unified_inventory.current_searchbox[player_name], "nochange")
		unified_inventory.set_inventory_formspec(player,
				unified_inventory.current_page[player_name])
		minetest.sound_play("paperflip2",
				{to_player=player_name, gain = 1.0})
	elseif fields.searchresetbutton then
		unified_inventory.apply_filter(player, "", "nochange")
		unified_inventory.current_searchbox[player_name] = ""
		unified_inventory.set_inventory_formspec(player,
				unified_inventory.current_page[player_name])
		minetest.sound_play("click",
				{to_player=player_name, gain = 0.1})
	end

	-- alternate buttons
	if not (fields.alternate or fields.alternate_prev) then
		return
	end
	minetest.sound_play("click",
			{to_player=player_name, gain = 0.1})
	local item_name = unified_inventory.current_item[player_name]
	if not item_name then
		return
	end
	local crafts = unified_inventory.crafts_for[unified_inventory.current_craft_direction[player_name]][item_name]
	if not crafts then
		return
	end
	local alternates = #crafts
	if alternates <= 1 then
		return
	end
	local alternate
	if fields.alternate then
		alternate = unified_inventory.alternate[player_name] + 1
		if alternate > alternates then
			alternate = 1
		end
	elseif fields.alternate_prev then
		alternate = unified_inventory.alternate[player_name] - 1
		if alternate < 1 then
			alternate = alternates
		end
	end
	unified_inventory.alternate[player_name] = alternate
	unified_inventory.set_inventory_formspec(player,
			unified_inventory.current_page[player_name])
end)

-- builder mod by Downad 
-- override the filter-function
--apply filter to the inventory list (create filtered copy of full one)
function unified_inventory.apply_filter(player, filter, search_dir)
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
		-- builder mod by Downad -> insert here ask for builder privileg 
		and (is_creative or unified_inventory.crafts_for.recipe[def.name] or builder.is_builder(player_name)) then
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
