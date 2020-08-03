extends Camera2D

export(int) var speed = 5

onready var curr_room_center = position;

func move(dir):
	var motion = Direction.dir2vec(dir) * 64
	var tween = $Tween
	tween.interpolate_property(
		self,
		"position",
		position,
		position + motion,
		1.0 / speed,
		Tween.TRANS_LINEAR)
	tween.start()
	yield(tween, "tween_completed")
	curr_room_center += motion

func should_move(pos):
	var diff = pos - curr_room_center
	return abs(diff.x) >= 32 or abs(diff.y) >= 32
