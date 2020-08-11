extends Area2D

signal death
signal starting_at_pos(pos)
signal entered_portal(portal)

enum VelocityState { LV_0 = 0, LV_1 = 1, LV_2 = 2, LV_3 = 3, LV_4 = 4 }

export (Array, Color) var velocityModulations;
export (Array, int) var velocitySpeeds;

onready var CELL_SIZE = 16
onready var level = get_tree().get_nodes_in_group("Level")[0]
onready var camera = $"../Camera2D"
onready var dir_ray = $MovementRayCast
onready var last_grid_pos = position
onready var last_grid_target = global_position

var move_vector_left = null

var next_dir = Direction.Dir.NONE
var curr_vel = VelocityState.LV_0
var curr_tile_combo = 0
var curr_tile_combo_penalty = 0

var is_grid_snapped = true
var is_frozen = false

func _ready():
	VisualServer.set_default_clear_color(Color.black)

func _process(delta):
	update_velocity()
	
	if is_grid_snapped and !is_frozen:
		move(next_dir)

func _input(event):
	if is_frozen: return
	
	var dir = Direction.Dir.NONE
	
	if event.is_action_pressed("move_up"):
		dir = Direction.Dir.UP
	elif event.is_action_pressed("move_down"):
		dir = Direction.Dir.DOWN
	elif event.is_action_pressed("move_left"):
		dir = Direction.Dir.LEFT
	elif event.is_action_pressed("move_right"):
		dir = Direction.Dir.RIGHT
	
	if dir != Direction.Dir.NONE and next_dir == Direction.Dir.NONE:
		next_dir = dir

func move(dir):
	var dir_vec = Direction.dir2vec(dir) * CELL_SIZE
	if move_vector_left != null:
		dir_vec = move_vector_left
		move_vector_left = null
	var dir_vec_complement = Direction.dir2vec(dir) * CELL_SIZE - dir_vec
	
	var target = position + dir_vec
	
	if target != position:
		var last_tile_pos = position - dir_vec_complement
		
		if !can_move_from_to(last_tile_pos, last_tile_pos + dir_vec):
			stop_movement()
			return
		
		if camera.should_move(target):
			camera.move(dir)
		
		var speed_normalizer =  (target - position).length() / CELL_SIZE
		var tween = $MovementTween
		tween.interpolate_property(
			self,
			"position",
			position,
			target,
			1.0 * speed_normalizer / get_curr_speed(),
			Tween.TRANS_LINEAR)
		tween.start()
		
		last_grid_target = target
		is_grid_snapped = false
	else:
		last_grid_target = target
		is_grid_snapped = true

func can_move_from_to(from_pos, to_pos):
	var hits = segment_cast(from_pos, to_pos)
	
	for collision in hits:
		var obj = collision.collider
		if obj.is_in_group("Rock"):
			if curr_vel < obj.resistance:
				return false
		if obj.is_in_group("LockedDoor"):
			if !obj.can_open():
				return false
			else:
				obj.open()
				return false
		elif obj.is_in_group("Borders") or obj.is_in_group("SolidWall"):
			return false
		
	return true

func handle_collision_arrive():
	var arrived_at = position
	
	for obj in get_tree().get_nodes_in_group("GridElement"):
		if obj.global_position == arrived_at:
			if obj.is_in_group("Key"):
				level.acquire_key(obj)
			elif obj.is_in_group("Rock"):
				if curr_vel >= obj.resistance:
					if curr_vel == obj.resistance:
						stop_movement()
					obj.destroy()
			elif obj.is_in_group("Hole"):
				if curr_vel < obj.resistance:
					fall_inside_hole()
			elif obj.is_in_group("Spring"):
				next_dir = obj.direction
#			elif obj.is_in_group("LockedDoor"):
#				if obj.can_open():
#					obj.open()
			elif obj.is_in_group("Portal"):
				enter_portal(obj)
			elif obj.is_in_group("SandTile"):
				# On leave
				yield($MovementTween, "tween_all_completed")
				curr_tile_combo_penalty += 6
			elif obj.is_in_group("BrokenTile"):
				# On leave
				yield($MovementTween, "tween_all_completed")
				obj.mark_passed()

func toggle_freeze(val):
	is_frozen = val
	if val:
		move_vector_left = last_grid_target - global_position
		$MovementTween.remove(self, "position")
	else:
		move(next_dir)

func die():
	stop_movement()
	emit_signal("death")

func update_velocity():
	var combo = curr_tile_combo - curr_tile_combo_penalty
	
	if combo > 24:
		curr_vel = VelocityState.LV_4
	elif combo > 18:
		curr_vel = VelocityState.LV_3
	elif combo > 12:
		curr_vel = VelocityState.LV_2
	elif combo > 6:
		curr_vel = VelocityState.LV_1
	else:
		curr_vel = VelocityState.LV_0
	
	modulate = velocityModulations[curr_vel]

func get_curr_speed():
	return velocitySpeeds[curr_vel]

func stop_movement():
	curr_tile_combo = 0
	curr_tile_combo_penalty = 0
	next_dir = Direction.Dir.NONE

func start_at_pos(pos):
	position = pos
	emit_signal("starting_at_pos", pos)

func segment_cast(begin_pos, end_pos):
	var space_state = get_world_2d().get_direct_space_state()

	var segment = SegmentShape2D.new()
	segment.set_a(begin_pos)
	segment.set_b(end_pos)

	var query = Physics2DShapeQueryParameters.new()
	query.set_collide_with_areas(true)
	query.set_shape(segment)
	query.set_exclude([self])

	var hits = space_state.intersect_shape(query, 32)
	return hits

func enter_portal(portal):
	stop_movement()
	$AnimationPlayer.play("enter_portal")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("entered_portal", portal)

func exit_portal(portal):
	is_frozen = true
	var dir = Direction.opposite_dir(portal.player_comes_from)
	var anim = null
	match dir:
		Direction.Dir.LEFT:
			anim = "exit_portal_left"
		Direction.Dir.RIGHT:
			anim = "exit_portal_right"
		Direction.Dir.UP:
			anim = "exit_portal_up"
		Direction.Dir.DOWN:
			anim = "exit_portal_down"
	visible = false
	global_position = portal.global_position + Direction.dir2vec(portal.player_comes_from) * 16
	$AnimationPlayer.play(anim)
	yield($AnimationPlayer, "animation_finished")
	is_frozen = false

func fall_inside_hole():
	stop_movement()
	is_frozen = true
	$AnimationPlayer.play("fall_in_hole")
	yield($AnimationPlayer, "animation_finished")
	die()

func _on_MovementTween_tween_all_completed():
	curr_tile_combo += 1
	is_grid_snapped = true
	
	handle_collision_arrive()
