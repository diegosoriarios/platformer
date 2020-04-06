extends KinematicBody2D

var Bullet = preload('res://Objects/BulletEnemy.tscn')
var timer
var allow_attack = true
export var bullets = 4
var frame = 0
var forma = 1
var hp = 50
var motion = Vector2()
const UP = Vector2.ZERO
var gravity = 10

func _ready():
	pass # Replace with function body.
	
func _process(delta):
	var player = get_parent().get_node("Player")
	$Area2D.look_at(player.get_position())
	
	frame += delta * 10
	
	if int(frame) % 10 == 0 and int(frame) != 0:
		allow_attack = true
	
	if forma == 2:
		if player.get_position().x > position.x:
			motion.x += gravity
		else:
			motion.x -= gravity
		motion = move_and_slide(motion, UP)
	elif forma == 3:
		$Area2D.rotate(.5)
		
	if allow_attack:
		shoot()
		allow_attack = false
		frame = 0

func shoot():
	if forma == 3:
		for i in 10:
			var bullet = Bullet.instance()
			bullet.start(self.position, $Area2D.rotation - deg2rad(i * 15), self, 150)
			get_parent().add_child(bullet)
	else:
		var deg = 360/bullets
		for i in range(bullets):
			var bullet = Bullet.instance()
			bullet.start(self.position, $Area2D.rotation - deg2rad(deg * i) , self)
			get_parent().add_child(bullet)

func hit():
	hp -= 1
	
	if hp == 30:
		forma = 2
	elif hp == 15:
		forma = 3
	elif hp == 0:
		queue_free()
