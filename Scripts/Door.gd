extends StaticBody2D

var is_opened = false

func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass

func open():
	$CollisionShape2D.scale = Vector2.ZERO
