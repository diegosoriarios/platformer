extends Node2D

export(Array, PackedScene) var enemies = []
export var time = 20
export var limit = 0

var frame = 0
var create_enemy = true
var obj = 0

func _ready():
	pass # Replace with function body.

func _process(delta):
	if limit == 0:
		generate(delta)
	else:
		obj += 1
		if obj <= limit:
			generate(delta)

func generate(delta):
	frame += delta * 10
	
	if int(frame) % int(time) == 0 and int(frame) != 0:
		create_enemy = true
	
	if create_enemy:
		create_enemy = false
		frame = 0
		enemies.shuffle()
		var Enemy = enemies.front()
		var enemy = Enemy.instance()
		enemy.position = self.position
		get_parent().add_child(enemy)
