extends Area2D

var speed = 50
var frame = 0
var direction = 1
var v_max = rand_range(20, 40)
var hp = 1
var Blood = preload("res://Objects/Blood.tscn")
var Explosion = preload("res://Objects/Effects/Explosion.tscn")

func _ready():
	pass # Replace with function body.
	
func _process(delta):
	frame += delta * 10
	if int(frame) % int(v_max) == 0 and int(frame) != 0:
		frame = 0
		direction *= -1
	self.position.x -= 1 * delta * speed
	self.position.y -= 1 * delta * speed * direction
	
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			body.set_take_damage(true)

func hit():
	hp -= 1
	if hp == 0:
		var file = "res://Assets/Sprites/Blood/" + str(int(rand_range(1, 43)))	 + ".png"
		var texture = load(file)
		var sprite = Sprite.new()
		sprite.set_texture(texture)
		sprite.position = position
		sprite.z_index = -3
		get_parent().add_child(sprite)
		
		var blood = Blood.instance()
		blood.global_position = global_position
		
		get_parent().add_child(blood)
		
		var explosion = Explosion.instance()
		explosion.scale = scale
		explosion.global_position = global_position
		get_parent().add_child(explosion)
		explosion.active()
		
		#$Explosion.active()
		
		queue_free()
