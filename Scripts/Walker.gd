extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()
var direction = 1

func _ready():
	add_collision_exception_with(get_parent().find_node("Player"))


func _process(delta):
	velocity = Vector2()
	velocity.x -= direction
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity)
	
	if is_on_wall():
		direction *= -1
