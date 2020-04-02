extends KinematicBody2D

var direction = 0
export var bullets = 1
var speed = 500
var allow_attack = true

var run_speed = 25
var velocity = Vector2.ZERO
var player
var Bullet = preload('res://Objects/BulletEnemy.tscn')
var frame = 0
var sSize
var gravity = 100
var motion = Vector2()
const UP = Vector2(0, 0)
var random 
var move = false

func _ready():
	randomize()
	random = int(rand_range(0, 4))
	player = get_parent().get_node("Player")
	sSize = self.scale
	velocity = position.direction_to(player.position) * speed
	
func _process(delta):
	#motion.x += gravity
	frame += delta * 10
	
	
	if random == 0:
		motion.x += speed
		motion.y = 0
	elif random == 1:
		motion.x -= speed
		motion.y = 0
	elif random == 2:
		motion.y += speed
		motion.x = 0
	elif random == 3:
		motion.y -= speed
		motion.x = 0
	
	if move:
		random = int(rand_range(0, 4))
		move = false
	
	if int(frame) % 20 == 0 and int(frame) != 0:
		move = true
	#$Area2D.look_at(player.get_position())
	
	
	
	#velocity = Vector2.ZERO
	#if player:
	#	velocity = position.direction_to(player.position) * run_speed
	#velocity = move_and_slide(velocity)
	
	var bodies = $Area2D.get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			body.set_take_damage(true)

	motion = move_and_slide(motion, Vector2.ZERO)

func hit():
	pass

