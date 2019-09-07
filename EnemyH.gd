extends KinematicBody2D

const UP = Vector2(0, -1)
var time = 0
var motion = Vector2()
var isGoingRight = false
var acceleration = 50
var max_speed = 200

func _physics_process(delta):
	time += delta
	
	if !isGoingRight:
		motion.x = max(motion.x - acceleration, -max_speed)
	else:
		motion.x = min(motion.x + acceleration, max_speed)

	if time >= 3.0:
		time = 0
		isGoingRight = !isGoingRight
	
	motion = move_and_slide(motion, UP)
	
func _ready():
	pass # Replace with function body.