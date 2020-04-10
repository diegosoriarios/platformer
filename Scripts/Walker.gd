extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()
var direction = 1
const UP = Vector2(0, -1)
var motion = Vector2()
var gravity = 10
var jump_force = -400
var acceleration = 50
var max_speed = 200

func _ready():
	add_collision_exception_with(get_parent().find_node("Player"))


func _process(delta):
	if is_on_wall():
		direction *= -1
	
	motion.y += gravity
	var friction = false
	
	if direction < 0:
		motion.x = min(motion.x + acceleration, max_speed)
	else:
		motion.x = max(motion.x - acceleration, -max_speed)
	
	motion = move_and_slide(motion, UP)

func hit():
	pass
