extends Area2D

export (PackedScene) var level_scene
export (int) var level_id
export (Direction.Dir) var player_comes_from

func _ready():
	if $"/root/Global".completed_levels.has(level_id):
		$AnimationPlayer.play("idle_incomplete")
	else:
		$AnimationPlayer.play("idle_complete")

func enter():
	$"/root/Global".last_portal_path_entered = get_path()
	get_tree().change_scene_to(level_scene)
