extends KinematicBody2D

var Bullet = preload('res://Objects/BulletEnemy.tscn')
var timer
var allow_attack = true
var direction = 0
export var bullets = 1

func _ready():
	pass # Replace with function body.
	
func _process(delta):
	var player = get_parent().get_node("Player").get_position()
	if player.y < self.position.y:
		direction = 1
	else:
		direction = 3
	
	if allow_attack:
		shoot()
		allow_attack = false
		
		timer = Timer.new()
		timer.wait_time = 1
		timer.connect("timeout", self, "on_timer_timeout")
		add_child(timer)
		timer.start()

func shoot():
	var deg = 15/bullets
	if bullets == 1:
		var bullet = Bullet.instance()
		bullet.start(self.position, deg2rad(-90 * direction), self)
		get_parent().add_child(bullet)
	else:
		for i in range(bullets):
			var bullet = Bullet.instance()
			var index = (90 * direction) + (deg * (i - 1))
			bullet.start(self.position, deg2rad(index), self)
			get_parent().add_child(bullet)

func on_timer_timeout():
	if timer and timer.time_left != 0:
		allow_attack = true
		remove_child(timer)
		timer.stop()
		timer = null

func pass():
	pass
