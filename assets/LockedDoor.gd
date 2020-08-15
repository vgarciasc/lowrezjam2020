extends Area2D

var associated_portal

func _ready():
	associated_portal = $"../Portal"
	
	if $"/root/Global".opened_doors.has(get_path()):
		destroy()

var is_open = false
func open():
	if is_open: return
	
	is_open = true
	$AnimationPlayer.play("open")
	$"/root/Global".opened_doors.append(get_path())
	$"/root/AudioPlayer".play_sfx($"/root/AudioPlayer".door_unlock_sfx)

func can_open():
	return $"/root/Global".completed_levels.has(associated_portal.get_level_name())

func destroy():
	queue_free()
