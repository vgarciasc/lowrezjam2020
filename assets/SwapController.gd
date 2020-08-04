extends Node2D

onready var camera = $"/root/Main/Camera2D"
onready var player = $"/root/Main/Player"

var selected_room = null
var selected_room_original_pos = Vector2.ZERO
var mouse_offset = Vector2.ZERO

var rooms = []

func _ready():
	for child in get_parent().get_children():
		if child.is_in_group("Room"):
			rooms.append(child)

func _process(delta):
	# Drag
	if selected_room != null:
		selected_room.position = get_global_mouse_position() + mouse_offset

func _input(event):
	var mouse_pos = get_global_mouse_position()
	
	if event.is_action_pressed("change_mode"):
		if camera.is_zoomed: 
			prepare_zoom_out()
		else:
			prepare_zoom_in()
		camera.toggle_zoom(null, player)
	
	if event is InputEventMouseButton and !camera.is_zoomed:
		var hovered_room = null
		for room in rooms:
			var room_rect = Rect2(room.position / 2, Vector2.ONE * 32)
			if room_rect.has_point(event.position):
				if room != selected_room:
					hovered_room = room
			
		if event.pressed:
			# Start dragging
			selected_room = hovered_room
			selected_room_original_pos = hovered_room.position
			mouse_offset = hovered_room.position - mouse_pos
		else:
			if hovered_room == null:
				# Reset
				selected_room.position = selected_room_original_pos
			else: 
				# Swap
				var aux_pos = selected_room_original_pos
				selected_room.position = hovered_room.position
				hovered_room.position = aux_pos
				
			mouse_offset = Vector2.ZERO
			selected_room = null

func prepare_zoom_out():
	for room in rooms:
		var room_rect = Rect2(room.position / 2, Vector2.ONE * 32)
		if room_rect.has_point(player.global_position):
			var player_global_pos = player.global_position
			player.get_parent().remove_child(player)
			room.add_child(player)
			player.set_owner(room)
			player.global_position = player_global_pos

func prepare_zoom_in():
	var player_global_pos = player.global_position
	player.get_parent().remove_child(player)
	$"/root/Main".add_child(player)
	player.set_owner($"/root/Main")
	player.global_position = player_global_pos
