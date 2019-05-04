# builder
For some cases the creative privileg is too much for a player who only wants to build some nice structure.
This player now can get a builder privileg.
 
The builder_admin can create a list of all items in game ("all_items_in_game.txt"), choose the blocks a builder-player can get. 
Change the **true** in the lines with blocks/tools or item you dont't want that builder-player can get to **false**. 
Save the file in worldpath with the filename: "allowed_items_for_builder.txt" 

# items
There are some special builder-items registed. Some armor and some tools.
armor: this are copies from armor3d without damage protection! -- see register_builder_3d_armor.lua
tools: this are copies from default without damage to player! -- see register_builder_tools.lua

	
# Dependencies
    * default 
    * unified_inventory
    * 3d_armor?


# Installation
Copy the modfolder to your mods.
As long as you did not create your own 'allowed_items_for_builder.txt' - copy this file from the builer mod to   minetest.get_worldpath()
To create your own List:
login as world-/admin-player and use the chat-command 'builder make_list' or give the builder_admin privileg to a player who should use that command.
Now all player with the builder privileg can get the allowed items and blocks as beeing creative.  

## Commands
* '/builder make_list'
	* the builder_admin can create a list of all items in game 
	* the list is saved in the minetest.get_worldpath() path with the filename "allowed_items_for_builder.txt"
	* there are same args to modify the list.
	**no_tools** - create a list without tools - see init.lua builder.tools{}
	**no_armor**  - create a list without tools - see init.lua builder.armor{}
	**no_mats**  - create a list without tools - see init.lua builder.mats{}
	**no_nogoup**  - create a list without tools - see init.lua builder.nogroup{}	
* example:
	'builder make_list strict' create a list off allowed items without tools, mats, armor and nogroup


## Version
* 0.1 	initial - register unified_inventory button,
    * privilegs "builder" for the player
    * "builder_admin" for the builder admin
    * command (builder_admin) to get a lsit of all items in the game
				
* 0.2 	override some unified_inventory function
    * minetest.register_on_player_receive_fields(function(player, formname, fields) to check for builder privileg
    * function unified_inventory.apply_filter(player, filter, search_dir)	to check for builder privileg
					
* 0.3	some tools an armor for builder - they don't protect and don't do fleshy damage
* 0.4 	some first tests, creating a first list of allowed items as allowed_items_for_builder.txt
* 0.5	load file "allowed_item_for_builder.txt" into a table. Check item for this table. 
* 0.6 	some changes to create "allowed_item_for_builder.txt"
* 0.7 	crate a log-entry in word-path for every item a builder-player gets


# Textures
* the armor from 3d armor
* the tools from default tools

# License
Copyright (C) 2018 Ralf Weinert - email. ralf.weinert@gmx.de

Code: Licensed under the GNU LGPL version 2.1 or later. 

See LICENSE.txt and http://www.gnu.org/licenses/lgpl-2.1.txt 


