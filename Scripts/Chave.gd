extends Area2D

var door

func _ready():
	door = get_parent().find_node("Door")


func _process(delta):
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			door.open()
			queue_free()
