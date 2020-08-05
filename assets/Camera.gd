extends Camera2D

export (int) var speed = 5

onready var player = $"../Player"
onready var level = get_tree().get_nodes_in_group("Level")[0]

func move(dir):
	$"../SwapController".toggle_zoom_lock(true)

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

	$"../SwapController".toggle_zoom_lock(false)
	
func should_move(pos):
	var diff = pos - position
	return abs(diff.x) >= 32 or abs(diff.y) >= 32

func toggle_zoom(val):
	$"../SwapController".toggle_zoom_lock(true)

	var tween = $Tween
	if val: #ZOOM IN
		tween.interpolate_property(self, "zoom",
			Vector2.ONE * 2, Vector2.ONE, 0.5, Tween.EASE_OUT)
		tween.interpolate_property(self, "position",
			Vector2.ONE * 64, 
			Vector2.ONE * 32 + 
				Vector2(
					floor((player.global_position.x - 8) / 64) * 64, 
					floor((player.global_position.y - 8) / 64) * 64),
			0.5, Tween.EASE_OUT)
	else: #ZOOM OUT
		player.toggle_freeze(true)
		tween.interpolate_property(self, "zoom",
			Vector2.ONE, Vector2.ONE * 2, 0.5, Tween.EASE_OUT)
		tween.interpolate_property(self, "position",
			position, Vector2.ONE * 64, 0.5, Tween.EASE_OUT)
			
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	if val:
		player.toggle_freeze(false)
	
	$"../SwapController".toggle_zoom_lock(false)
