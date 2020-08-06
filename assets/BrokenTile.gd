extends Area2D

export (PackedScene) var hole_scene

func mark_passed():
	var hole = hole_scene.instance()
	get_parent().add_child(hole)
	hole.position = position
	queue_free()
