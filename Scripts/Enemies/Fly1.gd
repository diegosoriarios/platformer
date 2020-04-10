extends Area2D

var speed = 50
var frame = 0
var direction = 1
var v_max = rand_range(20, 40)
var hp = 1

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
		var file = "res://Assets/Sprites/Blood/" + str(int(rand_range(0, 43))) + ".png"
		var texture = load(file)
		print(texture)
		var sprite = Sprite.new()
		sprite.set_texture(texture)
		sprite.position = position
		sprite.z_index = -3
		get_parent().add_child(sprite)
		queue_free()
