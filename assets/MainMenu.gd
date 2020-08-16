extends Node2D

signal coming_from_level_complete

func _ready():
	$"/root/Global".coming_from_main_menu = true
	
	if $"/root/Global".coming_from_level_complete:
		emit_signal("coming_from_level_complete")
	
	$"/root/AudioPlayer".play_music_main(false)
