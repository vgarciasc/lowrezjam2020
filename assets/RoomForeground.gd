extends TileMap
tool

export (Color) var normal_color
export (Color) var hovering_color

func _ready():
	toggle_hovering(false)

func toggle_hovering(val):
	modulate = hovering_color if val else normal_color
