extends TileMap
tool

export (Color) var normal_color
export (Color) var hovering_color
export (Color) var locked_color

func _ready():
	toggle_hovering(false)

func toggle_hovering(val, locked=false):
	if locked:
		modulate = locked_color if val else normal_color
	else:
		modulate = hovering_color if val else normal_color
