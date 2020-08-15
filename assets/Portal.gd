extends Area2D

export (PackedScene) var level_scene
export (Direction.Dir) var player_comes_from

func _ready():
	if $"/root/Global".completed_levels.has(get_level_name()):
		$AnimationPlayer.play("idle_incomplete")
	else:
		$AnimationPlayer.play("idle_complete")

func enter():
	$"/root/Global".last_lvl_entered = get_level_name()
	$"/root/Global".last_portal_path_entered = get_path()
	get_tree().change_scene_to(level_scene)

func get_level_name():
	return level_scene.resource_path.split("/")[-1].split(".")[0]
