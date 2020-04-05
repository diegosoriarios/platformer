extends Area2D

var next_level = [
	"res://Levels/" + '1' + ".tscn",
	"res://Levels/" + '2' + ".tscn"
]

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			global.double_jump_active = !global.double_jump_active
			next_level.shuffle()
			var first = next_level.front()
			print(first)
			#var level = first.instance()
			get_tree().change_scene(first)
