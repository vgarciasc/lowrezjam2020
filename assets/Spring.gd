extends Area2D

export (Direction.Dir) var direction = Direction.Dir.UP;

func set_direction(dir):
	direction = dir
	match direction:
		Direction.Dir.UP:
			rotation_degrees = 90
		Direction.Dir.RIGHT:
			rotation_degrees = 180
		Direction.Dir.DOWN:
			rotation_degrees = 270
		Direction.Dir.LEFT:
			rotation_degrees = 0
