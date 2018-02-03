# builder
For some cases the creative privileg is too much for a player who only wants to build some nice structure.
This player now can get a builder privileg. 
The builder_admin can create a list of all items in game ("all_items_in_game.txt"), 
choose the blocks a builder-player can get. For that only delete the lines with blocks/tools or item you dont't want that builder-player can get. Save the file in worldpath with the filename: "allowed_items_for_builder.txt" 
	
	
#x Dependencies
default 
unified_inventory
3d_armor?


#x Installation
Copy the modfolder to your mods.
As long as you did not create your own 'allowed_items_for_builder.txt' - copy this file from the builer mod to   minetest.get_worldpath().."/players/.
To create your own List:
login as world-/admin-player and use the chat-command 'builder make_list' or give the builder_admin privileg to a player who should use that command.
Modify the file minetest.get_worldpath().."/players/" path with the filename "all_items_in_game.txt" and rename it to 'allowed_items_for_builder.txt'
Now all player with the builder privileg can get the allowed items and blocks as beeing creative.  

## Commands
* '/builder make_list'
	* the buiilder_admin can create a list of all items in game 
	* the list is saved in the minetest.get_worldpath().."/players/" path with the filename "all_items_in_game.txt"
	

## Version
* 0.1		initial - register unified_inventory button,
    * privilegs "builder" for the player
    * "builder_admin" for the builder admin
    * command (builder_admin) to get a lsit of all items in the game
				
* 0.2 	override some unified_inventory function
    * minetest.register_on_player_receive_fields(function(player, formname, fields) to check for builder privileg
    * function unified_inventory.apply_filter(player, filter, search_dir)	to check for builder privileg
					
* 0.3		some tools an armor for builder - they don't protect and don't do fleshy damage
* 0.4 	some first tests, creating a first list of allowed items as allowed_items_for_builder.txt


# Textures
* the armor from 3d armor
* the tools from default tools

# License
Copyright (C) 2018 Ralf Weinert - email. ralf.weinert@gmx.de

Code: Licensed under the GNU LGPL version 2.1 or later. 
See LICENSE.txt and http://www.gnu.org/licenses/lgpl-2.1.txt 


