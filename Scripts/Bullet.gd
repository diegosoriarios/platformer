extends KinematicBody2D

var speed = 500
var velocity = Vector2()

var explosion = preload("res://Objects/Explosion.tscn").instance()

func start(pos, dir, ignore):
	rotation = dir
	add_collision_exception_with(ignore)
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		if collision.collider.has_method("hit"):
			collision.collider.hit()
	
	var bodies = $Area2D.get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "TileMap":
			queue_free()
		elif body.is_in_group("enemy"):
			var p = body.get_global_position() - self.get_global_position()
			explosion.position -= p
			body.add_child(explosion)
			queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
