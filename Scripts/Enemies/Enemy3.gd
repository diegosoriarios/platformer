extends KinematicBody2D

var direction = 0
export var bullets = 1
var speed = 200

var run_speed = 25
var velocity = Vector2.ZERO
var player
var hp = int(rand_range(15, 20))

func _ready():
	randomize()
	player = get_parent().get_node("Player")
	velocity = position.direction_to(player.position) * speed
	
func _process(delta):
	velocity = Vector2.ZERO
	if player:
		velocity = position.direction_to(player.position) * run_speed
	velocity = move_and_slide(velocity)
	
	var bodies = $Area2D.get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			body.set_take_damage(true)

func hit():
	hp -= 1
	
	if hp == 0:
		queue_free()
