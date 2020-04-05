extends KinematicBody2D

var Bullet = preload('res://Objects/BulletEnemy.tscn')
var timer
var allow_attack = true
var direction = 0
export var bullets = 1
var hp = int(rand_range(15, 20))

func _ready():
	randomize()
	
func _process(delta):
	var player = get_parent().get_node("Player").get_position()
	if player.y < self.position.y:
		direction = 1
	else:
		direction = 3
	
	if player.x > position.x:
		position.x += 2
	elif player.x < position.x:
		position.x -= 2
	
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

func hit():
	hp -= 1
	if hp == 0:
		queue_free()
