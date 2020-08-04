extends Node2D

var curr_keys = 0
var total_keys = 0
var loaded_rooms = 0

func acquire_key(key):
	curr_keys += 1
	key.queue_free()
	check_game_over()

func check_game_over():
	if curr_keys == total_keys:
		$"../CanvasLayer".show_victory_display()
		$"../Player".toggle_freeze(true)

func get_room_count():
	var room_count = 0
	for obj in get_children():
		if obj.is_in_group("Room"):
			room_count += 1
	return room_count	

func get_key_count():
	var key_count = 0
	for obj in get_children():
		if obj.is_in_group("Room"):
			for child in obj.get_node("Elements").get_children():
				if child.is_in_group("Key"):
					key_count += 1
	return key_count

func _on_Elements_replacement_completed():
	loaded_rooms += 1
	if loaded_rooms == get_room_count():
		total_keys = get_key_count()
