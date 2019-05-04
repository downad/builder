	
-- functions 
-- print_log to print a info on the screen with_modname	
function builder:print_log(print_string, with_modname)
	if with_modname > 0 then
		print("[MOD]"..builder.THIS_MOD)
	end
	print("     "..print_string)
end

function builder:load_allowed_items()
	-- if filename exists
	local filename = builder.filename
	local f = io.open(filename, "rb")
	minetest.log("action", "[MOD]"..builder.THIS_MOD.." -- checking filename!")
	if f then 
		f:close()
		-- read file allowed_items_for_builder.txt in an table
		minetest.log("action", "[MOD]"..builder.THIS_MOD.." -- checking filename = OK!")
		for line in io.lines(filename) do 
			-- normaly the line has three parts
			-- [1] item_name
			-- [2] = 
			-- [3] true / false {is the item allowed} 
			local value = string.split(line, " ") 
	--		minetest.log("action", "[MOD]"..builder.THIS_MOD.." -- line = "..line)
	--		minetest.log("action", "[MOD]"..builder.THIS_MOD.." -- value[1] = "..value[1])
	--		minetest.log("action", "[MOD]"..builder.THIS_MOD.." -- value[2] = "..value[2])
	--		minetest.log("action", "[MOD]"..builder.THIS_MOD.." -- value[3] = "..value[3])

			if value[3] == "true" then
				--builder.print_log("Allowed Item read: "..line, builder.PRINT_MODNAME_NO)
	--			minetest.log("action", "[MOD]"..builder.THIS_MOD.." -- allowed item = "..value[1])
				table.insert (builder.allowed_items, value[1]);
			end
		end
	end
	minetest.log("action", "[MOD]"..builder.THIS_MOD.." -- allowed items loaded!")
end

-- has player builder privileg?
function builder:is_builder(playername)
	return minetest.check_player_privs(playername, {builder=true})
end

function builder:create_log(player_name,item_by_name)
	-- if filename exists
	local filename = builder.logfile
	local date = os.date("%y.%m.%d %H:%M:%S")
	-- open file fpr appending or create a new file
	file = io.open(filename, "a+")
	file:write(date..": "..player_name.." gets "..item_by_name.."\n")
	-- closes the open file
	io.close(file)
end

-- read list and return can_get_this_item = true or false
function builder:player_can_get_this_item(item_by_name)
	local item_allowed = false
--	minetest.log("action", "[MOD]"..builder.THIS_MOD.." --  builder:player_can_get_this_item item_by_name = "..tostring(item_by_name) )

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
	builder:print_log("[MOD] builder: player can get this block/item: "..item_by_name.." yes/no "..tostring(item_allowed),builder.PRINT_MODNAME_YES)
	return item_allowed
end

-- check if the item is allowed
function builder:is_allowed(item_name, no_tools, no_armor, no_mats)
	local allowed = true
	--minetest.log("action", "[MOD]"..builder.THIS_MOD.." --  builder:is_allowed no_tools = "..tostring(no_tools) )
	--minetest.log("action", "[MOD]"..builder.THIS_MOD.." --  builder:is_allowed no_armor = "..tostring(no_armor) )
	--minetest.log("action", "[MOD]"..builder.THIS_MOD.." --  builder:is_allowed no_mats = "..tostring(no_mats) )
	-- if item_name is forbidden in one then it is vorbidden in all
	if no_tools == true and allowed == true then
		allowed = builder:string_in_table(item_name, builder.tools)
	end
	if no_armor == true and allowed == true then
		allowed = builder:string_in_table(item_name, builder.armor)
	end
	if no_mats == true and allowed == true then
		allowed = builder:string_in_table(item_name, builder.mats)
	end
	if no_nogroup == true and allowed == true then
		allowed = builder:string_in_table(item_name, builder.nogroup)
	end	minetest.log("action", "[MOD]"..builder.THIS_MOD.." --  builder:is_allowed allowed = "..tostring(allowed) )
	return allowed
end

function builder:string_in_table(item_name, given_table)
	-- builder items are always allowed
	if string.find(item_name, "builder:") ~= nil  then
		return true
	end
	for k,v in ipairs(given_table) do
		if string.find(item_name, v ) ~= nil then
			return false
		end
	end
	return true
end
