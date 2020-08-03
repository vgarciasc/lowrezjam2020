extends TileMap

export (PackedScene) var rock_scene

onready var size_x = get_cell_size().x
onready var size_y = get_cell_size().y
onready var ts = get_tileset()
onready var uc = get_used_cells()

func _ready():
	replace_tiles()

func replace_tiles():
	for pos in uc:
		var id = get_cell(pos.x, pos.y)
		var name = ts.tile_get_name(id)
		if name == "Rock":
			replace_tile_with_scene(pos, rock_scene.resource_path)

func replace_tile_with_scene(pos, scene):
	var node = load(scene).instance()
	node.position = Vector2(
		pos.x * size_x + (0.5 * size_x),
		pos.y * size_y + (0.5 * size_y))
	add_child(node)
	set_cell(pos.x, pos.y, -1)
