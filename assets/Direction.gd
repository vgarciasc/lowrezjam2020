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

static func angle_between(dir1, dir2):
	var angle = 0
	match dir2:
		Dir.UP:    angle = 0
		Dir.RIGHT: angle = 90
		Dir.DOWN:  angle = 180
		Dir.LEFT:  angle = 270
	match dir1:
		Dir.UP:    angle -= 0
		Dir.RIGHT: angle -= 90
		Dir.DOWN:  angle -= 180
		Dir.LEFT:  angle -= 270
	return angle
