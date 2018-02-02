-- Builder Tools
-- buildertools do no fleshy damage
-- pickaxe
minetest.register_tool("builder:pick_diamond", {
	description = "Builder Pickaxe",
	inventory_image = "default_tool_diamondpick.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=2.0, [2]=1.0, [3]=0.50}, uses=300, maxlevel=3},
		},
		damage_groups = {fleshy=0},
	},
	sound = {breaks = "default_tool_breaks"},
})

-- shovel
minetest.register_tool("builder:shovel_diamond", {
	description = "Builder Shovel",
	inventory_image = "default_tool_diamondshovel.png",
	wield_image = "default_tool_diamondshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[1]=1.10, [2]=0.50, [3]=0.30}, uses=300, maxlevel=3},
		},
		damage_groups = {fleshy=0},
	},
	sound = {breaks = "default_tool_breaks"},
})

-- axe
minetest.register_tool("builder:axe_diamond", {
	description = "Builder Axe",
	inventory_image = "default_tool_diamondaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.10, [2]=0.90, [3]=0.50}, uses=30, maxlevel=3},
		},
		damage_groups = {fleshy=0},
	},
	sound = {breaks = "default_tool_breaks"},
})
