-- Builder Armor
-- builder armor don't protect against fleschy damage
-- copy and modified from 3d armor
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

