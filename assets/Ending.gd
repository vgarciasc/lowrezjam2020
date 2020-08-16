extends Control

func _ready():
	$"/root/AudioPlayer".play_ending_music()
	yield(get_tree().create_timer(2.4), "timeout")
	$AnimationPlayer.play("ending")

func _input(event):
	if event.is_action_pressed("change_mode"):
		get_tree().reload_current_scene()

func go_to_title_screen():
	get_tree().change_scene("res://scenes/TitleScreen.tscn")
