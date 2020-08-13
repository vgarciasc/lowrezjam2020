extends Node

var coming_from_main_menu = false
var coming_from_level_complete = false

var last_portal_path_entered = "/root/MainMenu/Rooms/Room5/Portal"

var completed_levels = []
var opened_doors = []

static func safe_first_in_group(tree, group_name):
	var nodes = tree.get_nodes_in_group(group_name)
	if nodes.size() == 0:
		return null
	return nodes[0]
