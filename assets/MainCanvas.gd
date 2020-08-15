extends CanvasLayer

func _ready():
	if $"/root/Global".resetting_lvl:
		$"/root/Global".resetting_lvl = false
		toggle_blackscreen(true)
		yield(get_tree().create_timer(0.05), "timeout")
		toggle_blackscreen(false)

func show_victory_display():
#	$VictoryControl.visible = true
	$LevelComplete.visible = true
	$LevelComplete/ColorRect/AnimationPlayer.play("start")
	yield($LevelComplete/ColorRect/AnimationPlayer, "animation_finished")
	$LevelComplete/ColorRect/AnimationPlayer.play("idle_loop")

func show_game_over_display():
#	$GameOverControl.visible = true
	$LevelFailed.visible = true
	$LevelFailed/ColorRect/AnimationPlayer.play("start")
	yield($LevelFailed/ColorRect/AnimationPlayer, "animation_finished")
	$LevelFailed/ColorRect/AnimationPlayer.play("idle_loop")

func _on_RestartButton_pressed():
	get_tree().reload_current_scene()

func completed_lvl_to_main_menu():
	$"/root/Global".coming_from_level_complete = true
	$"/root/Global".completed_levels.append($"/root/Global".last_lvl_entered)
	get_tree().change_scene("res://scenes/MainMenu.tscn")

func _on_ProceedButton_pressed():
	completed_lvl_to_main_menu()

func toggle_blackscreen(val):
	$Blackscreen.visible = val
