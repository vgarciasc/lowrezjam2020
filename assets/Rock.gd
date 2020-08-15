extends Area2D

export(int) var resistance;

func destroy():
	$"/root/AudioPlayer".play_sfx($"/root/AudioPlayer".rock_smash_sfx)
	queue_free()
