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

func _physics_process(delta):
	motion.y += gravity
	var friction = false
	global.time += delta
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + acceleration, max_speed)
		
		$Sprite.play("run")
		$Sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - acceleration, -max_speed)
		
		$Sprite.play("run")
		$Sprite.flip_h = true
	else:
		$Sprite.play("idle")
		friction = true
		
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
	
	if global.time >= global.totalTime:
		global.time = 0
		global.deaths += 1
		global.totalTime = (global.deaths + 1) * 10
		get_tree().reload_current_scene()


func _ready():
	print("Motion ", motion)
	if global.xPos != 0 and global.yPos != 0:
		motion.x = global.xPos
		motion.y = global.yPos
		get_node(".").motion.x = global.xPos
		get_node(".").motion.y = global.yPos
		print("Motion ", motion)
		
	motion = move_and_slide(motion, UP)