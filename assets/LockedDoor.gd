extends Area2D

var associated_portal

func _ready():
	associated_portal = $"../Portal"
	
	if $"/root/Global".opened_doors.has(get_path()):
		destroy()

func open():
	$AnimationPlayer.play("open")
	$"/root/Global".opened_doors.append(get_path())

func can_open():
	return $"/root/Global".completed_levels.has(associated_portal.get_level_name())

func destroy():
	queue_free()
