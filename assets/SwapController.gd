extends Node2D

signal zoom_in
signal zoom_out

export (bool) var can_zoom = true

onready var camera = $"/root/Main/Camera2D"
onready var player = $"/root/Main/Player"
onready var rooms = get_tree().get_nodes_in_group("Room")

var selected_room = null
var selected_room_original_pos = Vector2.ZERO
var mouse_offset = Vector2.ZERO

var is_zoomed = true
var is_zoom_locked = false

func _process(delta):
	# Drag
	if selected_room != null:
		selected_room.position = get_global_mouse_position() + mouse_offset

func _input(event):
	var mouse_pos = get_global_mouse_position()
	
	if event.is_action_pressed("change_mode") and !is_zoom_locked and can_zoom \
		and selected_room == null:
		rooms[0].toggle_hovering(true)
		toggle_zoom()
	
	if event is InputEventMouseMotion and !is_zoomed:
		for room in rooms:
			var room_rect = Rect2(room.position / 2, Vector2.ONE * 32)
			if room_rect.has_point(event.position):
				if room != selected_room:
					room.toggle_hovering(true)
			else:
				room.toggle_hovering(false)
	
	if event is InputEventMouseButton and !is_zoomed:
		var hovered_room = null
		for room in rooms:
			var room_rect = Rect2(room.position / 2, Vector2.ONE * 32)
			if room_rect.has_point(event.position):
				if room != selected_room:
					hovered_room = room
			
		if event.pressed and event.button_index == BUTTON_LEFT:
			if hovered_room.can_swap():
				# Start dragging
				selected_room = hovered_room
				selected_room_original_pos = hovered_room.position
				mouse_offset = hovered_room.position - mouse_pos
				
				selected_room.toggle_swapping(true)
		else:
			if selected_room != null:
				if hovered_room == null or !hovered_room.can_swap():
					# Reset
					selected_room.position = selected_room_original_pos
				else:
					# Swap
					var aux_pos = selected_room_original_pos
					selected_room.position = hovered_room.position
					hovered_room.position = aux_pos
					
				selected_room.toggle_swapping(false)
			mouse_offset = Vector2.ZERO
			selected_room = null

func toggle_zoom():
	if is_zoomed:
		prepare_zoom_out()
		emit_signal("zoom_out")
	else:
		prepare_zoom_in()
		emit_signal("zoom_in")
	
	is_zoomed = !is_zoomed

func prepare_zoom_out():
	for room in rooms:
		var room_rect = Rect2(room.position, Vector2.ONE * 64)
		if room_rect.has_point(player.global_position):
			var player_global_pos = player.global_position
			player.get_parent().remove_child(player)
			room.add_child(player)
			player.set_owner(room)
			player.global_position = player_global_pos

func prepare_zoom_in():
	for room in rooms:
		room.toggle_hovering(false)
	
	var player_global_pos = player.global_position
	player.get_parent().remove_child(player)
	$"/root/Main".add_child(player)
	player.set_owner($"/root/Main")
	player.global_position = player_global_pos

func toggle_zoom_lock(val):
	is_zoom_locked = val
