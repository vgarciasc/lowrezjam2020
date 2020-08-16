extends Node2D

func _ready():
	$"/root/AudioPlayer".play_music_main(true)

func enter_game():
	get_tree().change_scene("res://scenes/Main.tscn")
