extends KinematicBody2D

var direction = 0
export var bullets = 16
var speed = 200
var timer
var allow_attack = true

var run_speed = 25
var velocity = Vector2.ZERO
var player
var Bullet = preload('res://Objects/BulletEnemy.tscn')
var forma = 1
var hp = 70
var yPos
var frame = 0

func _ready():
	player = get_parent().get_node("Player")
	velocity = position.direction_to(player.position) * speed
	yPos = position.y
	
func _process(delta):
	frame += delta * 10
	#$Area2D.look_at(player.get_position())
	$Area2D.rotate(.5)
	$Head.rotate(.2)
	$Horse.rotate(.2)
	$Goat.rotate(.2)
	
	if forma == 2:
		velocity = Vector2.ZERO
		if player:
			velocity = position.direction_to(player.position) * run_speed
		velocity = move_and_slide(velocity)
		position.y = yPos
	elif forma == 3:
		velocity = Vector2.ZERO
		if player:
			velocity = position.direction_to(player.position) * run_speed
		velocity = move_and_slide(velocity)
	
	var bodies = $Area2D.get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			body.set_take_damage(true)
	
	if int(frame) % 1 == 0 and int(frame) != 0:
		allow_attack = true
	
	if allow_attack:
		shoot()
		allow_attack = false
		frame = 0

func hit():
	hp -= 1
	
	if hp == 45:
		forma = 2
	elif hp == 20:
		forma = 3
	elif hp == 0:
		queue_free()

func shoot():
	if forma == 3:
		var bullet = Bullet.instance()
		bullet.start(self.position + $Horse.position, $Horse.rotation , self, 250)
		get_parent().add_child(bullet)
		bullet = Bullet.instance()
		bullet.start(self.position + $Head.position, $Head.rotation , self, 250)
		get_parent().add_child(bullet)
		bullet = Bullet.instance()
		bullet.start(self.position + $Goat.position, $Goat.rotation , self, 250)
		get_parent().add_child(bullet)
		
	else:
		var deg = 360/bullets
		for i in range(bullets):
			var bullet = Bullet.instance()
			bullet.start(self.position + $Head.position, $Area2D.rotation - deg2rad(deg * i) , self)
			get_parent().add_child(bullet)
			yield()
