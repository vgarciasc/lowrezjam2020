extends TextureRect

var quantity = 1.0

func _ready():
	pass # Replace with function body.

onready var label = $Label
onready var timer = $Timer
onready var load_game_timer = $"Load Game Timer"
onready var blink_timer = $"Blink Timer"

func _input(event) :
	if event.is_action_pressed("change_mode"):
		timer.start()
		blink_timer.stop()
		load_game_timer.start()
		label.visible = false


func increase_pixelated_amount():
	material.set_shader_param("quantity", quantity)
	quantity += 1

func blink_press_start() :
	label.visible = not label.visible


func _on_Timer_timeout():
	increase_pixelated_amount()


func _on_Blink_Timer_timeout():
	blink_press_start()


func _on_Load_Game_Timer_timeout():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
