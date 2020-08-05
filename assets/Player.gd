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

var is_grid_snapped = true
var is_frozen = false

func _process(delta):	
	dir_ray.set_cast_to(Direction.dir2vec(next_dir) * CELL_SIZE / 2)
	dir_ray.force_raycast_update()
	
	update_velocity()
	
	if dir_ray.is_colliding() and !is_frozen:
		var obj = dir_ray.get_collider()
		handle_collision(obj)
	
	if is_grid_snapped:
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

func handle_collision(obj):
	if obj.is_in_group("Rock"):
		if curr_vel < obj.resistance:
			stop_movement()
	elif obj.is_in_group("Key"):
		level.acquire_key(obj)
	elif obj.is_in_group("Borders"):
		stop_movement()
	elif obj.is_in_group("Hole"):
		die()

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
	if curr_tile_combo > 24:
		curr_vel = VelocityState.LV_4
	elif curr_tile_combo > 18:
		curr_vel = VelocityState.LV_3
	elif curr_tile_combo > 12:
		curr_vel = VelocityState.LV_2
	elif curr_tile_combo > 6:
		curr_vel = VelocityState.LV_1
	else:
		curr_vel = VelocityState.LV_0
	
	modulate = velocityModulations[curr_vel]

func get_curr_speed():
	return velocitySpeeds[curr_vel]

func stop_movement():
	curr_tile_combo = 0
	next_dir = Direction.Dir.NONE

func _on_MovementTween_tween_all_completed():
	curr_tile_combo += 1
	is_grid_snapped = true
