extends KinematicBody2D

var velocity = Vector2()

func start(pos, dir, ignore, speed = 500):
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
		if body.name == "Player":
			body.set_take_damage(true)
			queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
