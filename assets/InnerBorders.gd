extends Node2D

export (PackedScene) var inner_border_line

onready var rooms = get_tree().get_nodes_in_group("Room")

var lines = [[], [], [], []]

func _ready():
	for room in rooms:
		for y in range(0, 4):
			var tile_pos = Vector2(0, y)
			spawn_line_at(room.position + tile_pos * room.CELL_SIZE + Vector2(8, 8), Direction.Dir.LEFT)
		for y in range(0, 4):
			var tile_pos = Vector2(3, y)
			spawn_line_at(room.position + tile_pos * room.CELL_SIZE + Vector2(8, 8), Direction.Dir.RIGHT)
		for x in range(0, 4):
			var tile_pos = Vector2(x, 0)
			spawn_line_at(room.position + tile_pos * room.CELL_SIZE + Vector2(8, 8), Direction.Dir.UP)
		for x in range(0, 4):
			var tile_pos = Vector2(x, 3)
			spawn_line_at(room.position + tile_pos * room.CELL_SIZE + Vector2(8, 8), Direction.Dir.DOWN)
	
	deactivate_lines()
	activate_lines()

func deactivate_lines():
	for child in get_children():
		child.visible = false

func activate_lines():
	for room in rooms:
		var walls = room.get_node("Walls")
		var wall_tiles_in_room = get_wall_tiles_in_room(room)
		
		var room_left = get_room_left(room)
		var room_left_tiles = get_wall_tiles_in_room(room_left)
		var room_right = get_room_right(room)
		var room_right_tiles = get_wall_tiles_in_room(room_right)
		var room_up = get_room_up(room)
		var room_up_tiles = get_wall_tiles_in_room(room_up)
		var room_down = get_room_down(room)
		var room_down_tiles = get_wall_tiles_in_room(room_down)
		
		if room_left != null:
			for y in range(0, 4):
				var tile_pos = Vector2(0, y)
				if room_left_tiles.get_cellv(tile_pos + Vector2(3, 0)) == 7 and wall_tiles_in_room.get_cellv(tile_pos) != 7:
					activate_line_at(room.position + tile_pos * room.CELL_SIZE + Vector2(8, 8), Direction.Dir.LEFT)
		if room_right != null:
			for y in range(0, 4):
				var tile_pos = Vector2(3, y)
				if room_right_tiles.get_cellv(tile_pos + Vector2(-3, 0)) == 7 and wall_tiles_in_room.get_cellv(tile_pos) != 7:
					activate_line_at(room.position + tile_pos * room.CELL_SIZE + Vector2(8, 8), Direction.Dir.RIGHT)
		if room_up != null:
			for x in range(0, 4):
				var tile_pos = Vector2(x, 0)
				if room_up_tiles.get_cellv(tile_pos + Vector2(0, 3)) == 7 and wall_tiles_in_room.get_cellv(tile_pos) != 7:
					activate_line_at(room.position + tile_pos * room.CELL_SIZE + Vector2(8, 8), Direction.Dir.UP)
		if room_down != null:
			for x in range(0, 4):
				var tile_pos = Vector2(x, 3)
				if room_down_tiles.get_cellv(tile_pos + Vector2(0, -3)) == 7 and wall_tiles_in_room.get_cellv(tile_pos) != 7:
					activate_line_at(room.position + tile_pos * room.CELL_SIZE + Vector2(8, 8), Direction.Dir.DOWN)

func get_wall_tiles_in_room(room):
	if room == null:
		return []
	
	return room.get_node("Walls")

func spawn_line_at(global_pos, dir):
	var line = inner_border_line.instance()
	add_child(line)
	line.rotation_degrees = Direction.angle_between(Direction.Dir.UP, dir)
	line.global_position = global_pos
	lines[dir].append(line)

func activate_line_at(global_pos, dir):
	for line in lines[dir]:
		if line.global_position == global_pos:
			line.visible = true
			return

func get_room_left(room):
	for r in rooms:
		if r.position.x < room.position.x and r.position.y == room.position.y:
			return r
	return null

func get_room_right(room):
	for r in rooms:
		if r.position.x > room.position.x and r.position.y == room.position.y:
			return r
	return null
	
func get_room_up(room):
	for r in rooms:
		if r.position.x == room.position.x and r.position.y < room.position.y:
			return r
	return null

func get_room_down(room):
	for r in rooms:
		if r.position.x == room.position.x and r.position.y > room.position.y:
			return r
	return null
