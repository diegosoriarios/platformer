extends KinematicBody2D

var direction = 0
export var bullets = 1
var speed = 100
var timer
var allow_attack = true

var run_speed = 25
var velocity = Vector2.ZERO
var player
var Bullet = preload('res://Objects/BulletEnemy.tscn')
var frame = 0
var right = false
var sSize
var gravity = 100
var motion = Vector2()
const UP = Vector2(0, -1)

func _ready():
	player = get_parent().get_node("Player")
	sSize = self.scale
	velocity = position.direction_to(player.position) * speed
	
func _process(delta):
	motion.y += gravity
	frame += delta * 10
	
	if int(frame) % 20 == 0 and int(frame) != 0:
		frame = 0
		gravity *= -1
	#$Area2D.look_at(player.get_position())
	
	#velocity = Vector2.ZERO
	#if player:
	#	velocity = position.direction_to(player.position) * run_speed
	#velocity = move_and_slide(velocity)
	
	var bodies = $Area2D.get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			body.set_take_damage(true)
	
	if allow_attack:
		shoot()
		allow_attack = false
		timer = Timer.new()
		timer.wait_time = 2
		timer.connect("timeout", self, "on_timer_timeout")
		add_child(timer)
		timer.start()

	motion = move_and_slide(motion, UP)

func hit():
	pass

func shoot():
	var deg = 360/bullets
	for i in range(bullets):
		var bullet = Bullet.instance()
		bullet.start(self.position, $Area2D.rotation - deg2rad(deg * i) , self)
		get_parent().add_child(bullet)

func on_timer_timeout():
	allow_attack = true

