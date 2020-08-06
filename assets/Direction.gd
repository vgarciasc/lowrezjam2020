class_name Direction

enum Dir { 
	UP, DOWN, LEFT, RIGHT, NONE
}

static func dir2vec(dir):
	match dir:
		Dir.UP: 
			return Vector2.UP
		Dir.DOWN:
			return Vector2.DOWN
		Dir.LEFT:
			return Vector2.LEFT
		Dir.RIGHT:
			return Vector2.RIGHT
	return Vector2.ZERO

static func opposite_dir(dir):
	match dir:
		Dir.UP: 
			return Dir.DOWN
		Dir.DOWN:
			return Dir.UP
		Dir.LEFT:
			return Dir.RIGHT
		Dir.RIGHT:
			return Dir.LEFT
	return dir
