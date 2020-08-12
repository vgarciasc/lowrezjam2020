extends Camera2D

signal zoom_out_started
signal zoom_in_started
signal zoom_out_finished
signal zoom_in_finished

export (int) var speed = 5

onready var player = $"../Player"

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
		emit_signal("zoom_in_started")
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
		emit_signal("zoom_out_started")
		player.toggle_freeze(true)
		tween.interpolate_property(self, "zoom",
			Vector2.ONE, Vector2.ONE * 2, 0.5, Tween.EASE_OUT)
		tween.interpolate_property(self, "position",
			position, Vector2.ONE * 64, 0.5, Tween.EASE_OUT)
			
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	if val:
		emit_signal("zoom_in_finished")
		player.toggle_freeze(false)
	else:
		emit_signal("zoom_out_finished")
	
	$"../SwapController".toggle_zoom_lock(false)

func _on_Player_starting_at_pos(pos):
	if $"/root/Global".coming_from_main_menu:
		run_initial_zoom_in()
	else:
		position += Vector2(
			floor(pos.x / 64) * 64,
			floor(pos.y / 64) * 64)

func run_initial_zoom_in():
	$"../SwapController".toggle_zoom_lock(true)
	$"/root/Global".coming_from_main_menu = false
	player.is_frozen = true
	
	zoom = Vector2.ONE * 100
	position = Vector2.ONE * 64
	
	var tween = $Tween
	tween.interpolate_property(self, "zoom",
		zoom, Vector2.ONE * 2.2, 2.5, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	
	tween.interpolate_property(self, "zoom",
		zoom, Vector2.ONE * 2, 1.5, Tween.TRANS_LINEAR)
	tween.start()
	yield(tween, "tween_all_completed")
	
	toggle_zoom(true)

func _on_Player_entered_portal(portal):
	var tween = $Tween
	tween.interpolate_property(self, "zoom",
		zoom, Vector2.ONE * 0.01, 
		1.0, Tween.EASE_IN)
	tween.interpolate_property(self, "global_position",
		global_position, portal.global_position,
		1.0, Tween.TRANS_LINEAR)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	portal.enter()

func _on_MainMenu_coming_from_level_complete():
	$"/root/Global".coming_from_level_complete = false
	
	var portal = get_node($"/root/Global".last_portal_path_entered)
	var room_pos = Vector2.ONE * 32 + Vector2(
		floor(portal.global_position.x / 64) * 64,
		floor(portal.global_position.y / 64) * 64)
	
	zoom = Vector2.ONE * 0.01
	global_position = portal.global_position
	
	var tween = $Tween
	tween.interpolate_property(self, "zoom",
		Vector2.ONE * 0.01, Vector2.ONE,
		1.0, Tween.EASE_OUT)
	tween.interpolate_property(self, "global_position",
		global_position, room_pos,
		1.0, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	yield(get_tree().create_timer(1.0), "timeout")
	player.exit_portal(portal)
