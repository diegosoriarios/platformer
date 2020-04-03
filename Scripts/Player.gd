extends KinematicBody2D

const UP = Vector2(0, -1)
var motion = Vector2()
var speed = 200
var gravity = 10
var jump_force = -400
var acceleration = 50
var max_speed = 200
var jumps = 0
export(String, FILE, "*.tscn") var next_level
var gun = 0
var take_damage setget set_take_damage
var frame = 0
var crouch = false
var stand
var face_right = true

var Bullet = preload('res://Objects/Bullet.tscn')

func _process(delta):
	if take_damage:
		frame += delta * 10
		$Sprite.visible = false if int(frame) % 2 == 0 else true
		if (int(frame) >= 10): on_timer_timeout()

func _physics_process(delta):
	motion.y += gravity
	var friction = false
	global.time += delta
	
	$Muzzle.look_at(get_global_mouse_position())
	
	if crouch:
		$CollisionShape2D.scale.y = stand.y / 2
	else:
		$CollisionShape2D.scale.y = stand.y
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	if Input.is_action_pressed("ui_down"):
		crouch = true
	
	if Input.is_action_just_released("ui_down"):
		crouch = false
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + acceleration, max_speed)
		
		$Sprite.play("run")
		$Sprite.flip_h = false
		$Muzzle.position.x = 10
		$Area2D/CollisionShape2D.position.x = 8.5
		face_right = true
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - acceleration, -max_speed)
		
		$Sprite.play("run")
		$Sprite.flip_h = true
		$Muzzle.position.x = 5
		$Area2D/CollisionShape2D.position.x = -17
		face_right = false
	else:
		$Sprite.play("idle")
		friction = true
	
	if global.has_wings:
		if Input.is_action_pressed("ui_up"):
			motion.y = jump_force
	
	if is_on_floor():
		jumps = 0
		if Input.is_action_just_pressed("ui_up"):
			motion.y = jump_force
			jumps += 1
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.2)
	else:
		if Input.is_action_just_pressed("ui_up") and jumps < 2 and global.double_jump_active == true:
			motion.y = jump_force
			jumps += 1
		if motion.y < 0:
			$Sprite.play("jump")
		else:
			$Sprite.play("fall")
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)
	
	motion = move_and_slide(motion, UP)
	
	$Sprite/Label.text = str(int(global.time))
	$Sprite/Label2.text = str(global.deaths)
	$Sprite/Label3.text = str(global.totalTime)
	
	#if global.time >= global.totalTime:
	#	global.time = 0
	#	global.deaths += 1
	#	global.totalTime = (global.deaths + 1) * 10
	#	get_tree().reload_current_scene()
	
	var bodies = $Area2D.get_overlapping_bodies()
	
	if global.wall_jump:
		for body in bodies:
			if body.name == "TileMap":
				if Input.is_action_just_pressed("ui_up"):
					motion.y = jump_force * .7
					if face_right:
						motion.x -= 300
					else:
						motion.x += 300
					jumps += 1
				if friction == true:
					motion.x = lerp(motion.x, 0, 0.2)


func _ready():
	var startPosition = get_parent().find_node("initPos").position
	position = startPosition
	if global.xPos != 0 and global.yPos != 0:
		motion.x = global.xPos
		motion.y = global.yPos
		get_node(".").motion.x = global.xPos
		get_node(".").motion.y = global.yPos
		
	motion = move_and_slide(motion, UP)
	
	stand = $CollisionShape2D.scale

func shoot():
	if gun == 0:
		var bullet = Bullet.instance()
		bullet.start($Muzzle.global_position, $Muzzle.rotation, self)
		get_parent().add_child(bullet)
	elif gun == 1:
		var bullet1 = Bullet.instance()
		var bullet2 = Bullet.instance()
		var bullet3 = Bullet.instance()
		bullet1.start($Muzzle.global_position, $Muzzle.rotation, self)
		bullet2.start($Muzzle.global_position, $Muzzle.rotation + deg2rad(15), self)
		bullet3.start($Muzzle.global_position, $Muzzle.rotation - deg2rad(15), self)
		get_parent().add_child(bullet1)
		get_parent().add_child(bullet2)
		get_parent().add_child(bullet3)

func on_timer_timeout():
	$Sprite.visible = true
	frame = 0
	set_take_damage(false)

func set_take_damage(new_value):
	take_damage = new_value
