extends Node2D

export (int) var CELL_SIZE = 16
export (int) var lvl_id = -1

export (bool) var can_reset = true

func _input(event):
	if event.is_action_pressed("reset_lvl") and can_reset:
		$"../CanvasLayer".toggle_blackscreen(true)
		yield(get_tree().create_timer(0.2), "timeout")
		$"/root/Global".resetting_lvl = true
		get_tree().reload_current_scene()
	
#	if event.is_action_pressed("go_to_lvl_select"):
#		get_tree().change_scene("res://scenes/LevelSelection.tscn")
