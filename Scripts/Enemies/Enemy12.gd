extends KinematicBody2D

var Bullet = preload('res://Objects/BulletEnemy2.tscn')
var timer
var allow_attack = true
var direction = 0
export var bullets = 3
var frame = 0
var player

func _ready():
	pass # Replace with function body.
	
func _process(delta):
	player = get_parent().get_node("Player").get_position()
	if player.x < self.position.x:
		direction = 1
	else:
		direction = 0
	
	if allow_attack:
		shoot()
		allow_attack = false
		
		timer = Timer.new()
		timer.wait_time = 2
		timer.connect("timeout", self, "on_timer_timeout")
		add_child(timer)
		timer.start()

func shoot():
	var deg = 15/bullets
	if bullets == 1:
		var bullet = Bullet.instance()
		bullet.start(self.position)
		get_parent().add_child(bullet)
	else:
		for i in range(bullets):
			var bullet = Bullet.instance()
			bullet.start(self.position)
			get_parent().add_child(bullet)

func on_timer_timeout():
	if timer and timer.time_left != 0:
		allow_attack = true
		remove_child(timer)
		timer.stop()
		timer = null


func hit():
	pass
