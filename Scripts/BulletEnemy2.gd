extends KinematicBody2D

var speed = 500
var velocity = Vector2()

const UP = Vector2(0, -1)
var motion = Vector2()
var gravity = 10
var jump_force = -400
var acceleration = 50
var max_speed = 200
var jumps = 0
var frame = 0
var target
var random

func start(pos):
	randomize()
	position = pos
	random = Vector2(rand_range(-5, 5), 0)
	target = position + random
	gravity = -10
	rotation = deg2rad(-90)

func _physics_process(delta):
	motion.y += gravity
	gravity += .35
	var friction = false
	if random.x > 0:
		if rotation < 90:
			rotation += deg2rad(2)
		if position.x < target.x:
			motion.x += 8
	else:
		if rotation < 270:
			rotation -= deg2rad(2)
		if position.x > target.x:
			motion.x -= 8
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		if collision.collider.has_method("hit"):
			collision.collider.hit()
	
	var bodies = $Area2D.get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "TileMap":
			queue_free()
		if body.name == "Player":
			body.set_take_damage(true)
			queue_free()
	
	motion = move_and_slide(motion, UP)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
