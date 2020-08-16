extends Control

func _ready():
	yield(get_tree().create_timer(3.0), "timeout")
	$AnimationPlayer.play("ending")
