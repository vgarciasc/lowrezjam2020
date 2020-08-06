extends Area2D

export(int) var resistance;

func destroy():
	queue_free()
