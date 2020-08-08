extends TileMap
tool

export (Color) var normal_color
export (Color) var swapping_color
export (Color) var hovering_color

func _ready():
	toggle_swapping(false)

func toggle_swapping(val):
	modulate = swapping_color if val else normal_color
