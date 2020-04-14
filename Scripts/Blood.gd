extends Node2D

var frame = 0
const UP = Vector2(0, -1)
var motion = Vector2()
var gravity = 100

func _ready():
	$Particles2D.emitting = true


func _physics_process(delta):
	frame += delta * 10
	
	if int(frame > 15):
		queue_free()
