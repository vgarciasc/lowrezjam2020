extends TileMap

export (PackedScene) var rock_scene
export (PackedScene) var key_scene
export (PackedScene) var hole_scene
export (PackedScene) var broken_tile_scene
export (PackedScene) var sand_tile_scene
export (PackedScene) var spring_scene

signal replacement_completed

onready var size_x = get_cell_size().x
onready var size_y = get_cell_size().y
onready var ts = get_tileset()
onready var uc = get_used_cells()

func _ready():
	connect(
		"replacement_completed",
		get_parent().get_parent(),
		"_on_Elements_replacement_completed")
	replace_tiles()

func replace_tiles():
	for pos in uc:
		var id = get_cell(pos.x, pos.y)
		var name = ts.tile_get_name(id)
		
		if name == "Rock":
			replace_tile_with_scene(pos, rock_scene)
		elif name == "Key":
			replace_tile_with_scene(pos, key_scene)
		elif name == "Hole":
			replace_tile_with_scene(pos, hole_scene)
		elif name == "BrokenTile":
			replace_tile_with_scene(pos, broken_tile_scene)
		elif name == "SandTile":
			replace_tile_with_scene(pos, sand_tile_scene)
		elif name.begins_with("Spring"):
			var obj = replace_tile_with_scene(pos, spring_scene)
			var dir = Direction.Dir.NONE
			var name_id = name.split("_")[1]
			match name_id:
				"L": 
					dir = Direction.Dir.LEFT
				"R": 
					dir = Direction.Dir.RIGHT
				"D": 
					dir = Direction.Dir.DOWN
				"U": 
					dir = Direction.Dir.UP
			obj.set_direction(dir)
		elif name == "StartingPos":
			spawn_player_at(pos)
	
	emit_signal("replacement_completed")

func replace_tile_with_scene(pos, scene):
	var node = scene.instance()
	node.position = Vector2(
		pos.x * size_x + (0.5 * size_x),
		pos.y * size_y + (0.5 * size_y))
	add_child(node)
	set_cell(pos.x, pos.y, -1)
	return node

func spawn_player_at(pos):
	var player = get_tree().get_nodes_in_group("Player")[0]
	var room_pos = get_parent().position
	var tile_pos = Vector2(
		pos.x * size_x + (0.5 * size_x),
		pos.y * size_y + (0.5 * size_y))
	player.start_at_pos(room_pos + tile_pos)
	set_cell(pos.x, pos.y, -1)
