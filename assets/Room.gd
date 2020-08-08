extends Node2D

export var WIDTH = 4
export var HEIGHT = 4
export var CELL_SIZE = 16

#func _ready():
#	print(get_tile_at(Vector2(25, 39)))

func contains_pos(target):
	var rect = Rect2(position, Vector2(WIDTH, HEIGHT) * CELL_SIZE)
	return rect.has_point(target)

func get_tile_at(target):
	var cell_size = $Floor.get_cell_size()
	var uc = $Floor.get_used_cells()
	
	for pos in uc:
		var tile_pos = Vector2(pos.x * cell_size.x, pos.y * cell_size.y)
		tile_pos += global_position
		var rect = Rect2(tile_pos, cell_size)
		if rect.has_point(target):
			return tile_pos
	
	return null

func toggle_swapping(val):
	z_index = 1 if val else 0
	$Floor.toggle_swapping(val)

func toggle_hovering(val):
	$Foreground.toggle_hovering(val)
