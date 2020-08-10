extends Area2D

func be_acquired():
	var particles = $Particles2D
	
	remove_child(particles)
	get_parent().add_child(particles)
	particles.set_owner(get_parent())
	particles.global_position = global_position
	particles.set_emitting(true)
	
	queue_free()
