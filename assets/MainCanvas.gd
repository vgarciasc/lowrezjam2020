extends CanvasLayer

func _ready():
	$VictoryControl.visible = false
	$GameOverControl.visible = false

func show_victory_display():
	$VictoryControl.visible = true

func show_game_over_display():
	$GameOverControl.visible = true

func _on_RestartButton_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")
