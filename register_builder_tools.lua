-- Builder Armor
-- buildr armor dont protect against fleschy damage
	armor:register_armor("builder:helmet_builder", {
		description = "Builder Helmet",
		inventory_image = "builder_inv_helmet_builder.png",
		groups = {armor_head=1, armor_heal=0, armor_use=100, armor_fire=1},
		armor_groups = {fleshy=0},
		damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
	})
	armor:register_armor("builder:chestplate_builder", {
		description = "Builder Chestplate",
		inventory_image = "builder_inv_chestplate_builder.png",
		groups = {armor_torso=1, armor_heal=0, armor_use=100, armor_fire=1},
		armor_groups = {fleshy=0},
		damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
	})
	armor:register_armor("builder:leggings_builder", {
		description = "Builder Leggings",
		inventory_image = "builder_inv_leggings_builder.png",
		groups = {armor_legs=1, armor_heal=0, armor_use=100, armor_fire=1},
		armor_groups = {fleshy=0},
		damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
	})
	armor:register_armor("builder:boots_builder", {
		description = "Builder Boots",
		inventory_image = "builder_inv_boots_builder.png",
		groups = {armor_feet=1, armor_heal=0, armor_use=100, physics_speed=1,
				physics_jump=0.5, armor_fire=1},
		armor_groups = {fleshy=0},
		damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
	})
--end


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
