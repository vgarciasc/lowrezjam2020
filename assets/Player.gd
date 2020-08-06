extends Area2D

signal death

enum VelocityState { LV_0 = 0, LV_1 = 1, LV_2 = 2, LV_3 = 3, LV_4 = 4 }

export (Array, Color) var velocityModulations;
export (Array, int) var velocitySpeeds;

onready var CELL_SIZE = $"/root/Main/LevelData".CELL_SIZE;
onready var level = get_tree().get_nodes_in_group("Level")[0]
onready var camera = $"../Camera2D"
onready var dir_ray = $MovementRayCast

var move_vector_left = null
var last_target = Vector2.ZERO

var next_dir = Direction.Dir.NONE
var curr_vel = VelocityState.LV_0
var curr_tile_combo = 0
var curr_tile_combo_penalty = 0

var is_grid_snapped = true
var is_frozen = false

func _process(delta):	
	update_velocity()
	
	if !is_frozen:
		handle_collision_enter(next_dir)
	
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
	
	var target = position + dir_vec
	
	if target != position:
		if camera.should_move(target):
			camera.move(dir)
		
		var tween = $MovementTween
		tween.interpolate_property(
			self,
			"position",
			position,
			target,
			1.0 / get_curr_speed(),
			Tween.TRANS_LINEAR)
		tween.start()
		
		last_target = target
		is_grid_snapped = false

func handle_collision_enter(dir):
	dir_ray.position = Direction.dir2vec(dir) * CELL_SIZE / 2
	dir_ray.set_cast_to(Direction.dir2vec(dir) * CELL_SIZE / 2)
	dir_ray.force_raycast_update()
	
	if !dir_ray.is_colliding() or is_frozen:
		return
	
	var obj = dir_ray.get_collider()
	
	if obj.is_in_group("Rock"):
		if curr_vel < obj.resistance:
			stop_movement()
		else:
			obj.destroy()
	elif obj.is_in_group("Borders"):
		stop_movement()

func handle_collision_arrive():
	dir_ray.position = Vector2.ZERO
	dir_ray.set_cast_to(Vector2.DOWN)
	dir_ray.force_raycast_update()
	
	if !dir_ray.is_colliding() or is_frozen:
		return
	
	var obj = dir_ray.get_collider()
	
	if obj.is_in_group("Key"):
		level.acquire_key(obj)
#	elif obj.is_in_group("SandTile"):
#		if curr_vel >= 1:
#			curr_vel -= 1
	elif obj.is_in_group("Hole"):
		if curr_vel <= obj.resistance:
			die()

func handle_collision_leave(dir):
	dir_ray.position = Direction.dir2vec(dir) * CELL_SIZE / 2 * 1.1
	dir_ray.set_cast_to(Direction.dir2vec(dir) * CELL_SIZE / 2)
	dir_ray.force_raycast_update()
	
	if !dir_ray.is_colliding() or is_frozen:
		return
	
	var obj = dir_ray.get_collider()
	
	if obj.is_in_group("BrokenTile"):
		obj.mark_passed()

func toggle_freeze(val):
	is_frozen = val
	if val:
		move_vector_left = last_target - global_position
		$MovementTween.remove(self, "position")
	else:
		move(next_dir)

func die():
	stop_movement()
	emit_signal("death")

func update_velocity():
	var combo = curr_tile_combo
	
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

func _on_MovementTween_tween_all_completed():
	curr_tile_combo += 1
	is_grid_snapped = true
	
	handle_collision_arrive()
	handle_collision_leave(Direction.opposite_dir(next_dir))
