extends Control

func load_level(num):
	get_tree().change_scene("res://scenes/Level_" + str(num) + ".tscn")
