extends CanvasLayer

func _ready():
	$VictoryControl.visible = false
	$GameOverControl.visible = false

func show_victory_display():
	$VictoryControl.visible = true

func show_game_over_display():
	$GameOverControl.visible = true

func _on_RestartButton_pressed():
	get_tree().reload_current_scene()

func completed_lvl_to_main_menu():
	$"/root/Global".coming_from_level_complete = true
	$"/root/Global".completed_levels.append($"../LevelData".lvl_id)
	get_tree().change_scene("res://scenes/MainMenu.tscn")

func _on_ProceedButton_pressed():
	completed_lvl_to_main_menu()
