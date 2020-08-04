extends Camera2D

export (int) var speed = 5

var is_zoomed = true

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

func should_move(pos):
	var diff = pos - position
	return abs(diff.x) >= 32 or abs(diff.y) >= 32

func toggle_zoom(val=null, player=null):
	if val == null:
		toggle_zoom(!is_zoomed, player)
		return
	
	var tween = $Tween
	if val: #ZOOM IN
		tween.interpolate_property(self, "zoom",
			Vector2.ONE * 2, Vector2.ONE, 0.5, Tween.EASE_OUT)
		tween.interpolate_property(self, "position",
			Vector2.ONE * 64, 
			Vector2.ONE * 32 + 
				Vector2(
					floor(player.global_position.x / 32) * 32, 
					floor(player.global_position.y / 32) * 32),
			0.5, Tween.EASE_OUT)
	else: #ZOOM OUT
		tween.interpolate_property(self, "zoom",
			Vector2.ONE, Vector2.ONE * 2, 0.5, Tween.EASE_OUT)
		tween.interpolate_property(self, "position",
			position, Vector2.ONE * 64, 0.5, Tween.EASE_OUT)
			
	tween.start()
	is_zoomed = val
