extends Area2D

var frame = 0
var attack = false
var shapeArea

func _ready():
	shapeArea = $CollisionPolygon2D.scale

func _process(delta):
	frame += delta * 10
	
	if attack:
		var bodies = get_overlapping_bodies()
	
		for body in bodies:
			if body.name == "Player":
				body.set_take_damage(true)
				#queue_free()
		
		$CollisionPolygon2D.scale = shapeArea
		$Shape.visible = true
	else:
		$CollisionPolygon2D.scale = Vector2.ZERO
		$Shape.visible = false
	
	if int(frame) % 20 == 0 and int(frame) != 0:
		attack = !attack
		frame = 0
