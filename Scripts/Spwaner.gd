extends Node2D

export(Array, PackedScene) var enemies = []

var frame = 0
var create_enemy = true

func _ready():
	pass # Replace with function body.

func _process(delta):
	frame += delta * 10
	
	if int(frame) % 20 == 0 and int(frame) != 0:
		create_enemy = true
	
	if create_enemy:
		create_enemy = false
		frame = 0
		enemies.shuffle()
		var Enemy = enemies.front()
		var enemy = Enemy.instance()
		enemy.position = self.position
		get_parent().add_child(enemy)
