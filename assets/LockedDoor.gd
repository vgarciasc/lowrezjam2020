extends Area2D

export (int) var lvl_id

func _ready():
	if $"/root/Global".opened_doors.has(lvl_id):
		destroy()

func open():
	$AnimationPlayer.play("open")
	$"/root/Global".opened_doors.append(lvl_id)

func can_open():
	return $"/root/Global".completed_levels.has(lvl_id)

func destroy():
	queue_free()
