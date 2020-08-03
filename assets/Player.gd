extends Area2D

enum VelocityState { LV_0 = 0, LV_1 = 1, LV_2 = 2, LV_3 = 3, LV_4 = 4 }

export var speed = 5;

onready var CELL_SIZE = $"/root/Main/LevelData".CELL_SIZE;
onready var camera = $"../../Camera2D"
onready var dir_ray = $MovementRayCast

var next_dir = Direction.Dir.NONE
var curr_vel = VelocityState.LV_0

var is_grid_snapped = true

func _process(delta):	
	dir_ray.set_cast_to(Direction.dir2vec(next_dir) * CELL_SIZE)
	dir_ray.force_raycast_update()
	
	if dir_ray.is_colliding():
		var obj = dir_ray.get_collider()
		handle_collision(obj)
	
	if is_grid_snapped:
		move(next_dir)

func _input(event):
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
	var target = position + Direction.dir2vec(dir) * CELL_SIZE
	
	if target != position:
		if camera.should_move(target):
			camera.move(dir)
		
		var tween = $MovementTween
		tween.interpolate_property(
			self,
			"position",
			position,
			target,
			1.0 / speed,
			Tween.TRANS_LINEAR)
		tween.start()
		
		is_grid_snapped = false

func handle_collision(obj):
	if obj.is_in_group("Rock"):
		if curr_vel < obj.resistance:
			next_dir = Direction.Dir.NONE
	elif obj.is_in_group("Borders"):
		next_dir = Direction.Dir.NONE

func _on_MovementTween_tween_all_completed():
	is_grid_snapped = true
