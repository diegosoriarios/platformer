extends KinematicBody2D

var Bullet = preload('res://Objects/BulletEnemy.tscn')
var timer
var allow_attack = true
export var bullets = 4

func _ready():
	pass # Replace with function body.
	
func _process(delta):
	var player = get_parent().get_node("Player").get_position()
	$Area2D.look_at(player)
	
	if allow_attack:
		shoot()
		allow_attack = false
		timer = Timer.new()
		timer.wait_time = 2
		timer.connect("timeout", self, "on_timer_timeout")
		add_child(timer)
		timer.start()

func shoot():
	var deg = 360/bullets
	for i in range(bullets):
		var bullet = Bullet.instance()
		bullet.start(self.position, $Area2D.rotation - deg2rad(deg * i) , self)
		get_parent().add_child(bullet)

func on_timer_timeout():
	allow_attack = true
