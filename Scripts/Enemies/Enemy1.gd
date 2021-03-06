extends KinematicBody2D

var Bullet = preload('res://Objects/BulletEnemy.tscn')
var timer
var allow_attack = true
var direction = 0
export var bullets = 1
var hp = int(rand_range(15, 20))
var can_attack = false

func _ready():
	randomize()
	
func _process(delta):
	#var player = get_parent().get_node("Player").get_position()
	var player = get_parent().get_node("Player")
	if player.get_position().x < self.position.x:
		direction = 1
	else:
		direction = 0
	
	if player.find_node("Camera2D").get_viewport().get_visible_rect().size.x/2 + player.position.x > position.x:
		can_attack = true
	if position.x < player.position.x - player.find_node("Camera2D").get_viewport().get_visible_rect().size.x/2:
		can_attack = false

	
	if allow_attack and can_attack:
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
		bullet.start(self.position, deg2rad(180 * direction), self)
		get_parent().add_child(bullet)
	else:
		for i in range(bullets):
			var bullet = Bullet.instance()
			var index = (180 * direction) + (deg * (i - 1))
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
