extends Area2D

export (PackedScene) var level_scene
export (Direction.Dir) var player_comes_from

func _ready():
	$AnimationPlayer.play("idle")

func enter():
	$"/root/Global".last_portal_path_entered = get_path()
	get_tree().change_scene_to(level_scene)
