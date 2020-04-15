extends Node2D

var objNode = load("res://Objects/Effects/Obj.tscn")
var obj = []
var drops = []
#const height = 300
const height = 600
#const width = 512
const width = 1024
var pos = Vector2.ZERO#(width * 0.5, height - 64)
var GRAVITY = .3
const DAMPING = 0.999
var timer = 0
var frames = 0
var detonat = false
var VoD = 5
var texture

class Fragmentation:
	var old
	var new
	func _init(arg1, arg2): 
		old = Vector2(arg1, arg2)
		new = old
	
	func integrate():
		var velocity = velocity()
		old = new
		new += velocity * DAMPING
	
	func velocity():
		return (new - old)
	
	func move(offset_x, offset_y):
		new += Vector2(offset_x, offset_y)

	func bounce():
		#if (new.y > height):
		#	var velocity = velocity()
		#	old.y = height
		#	new.y = old.y - velocity.y * .3
		
		if new.x < 0 or new.x > width:
			new.x = 0
		
		return new

func img():
	for n in range(25):
		var node = objNode.instance()
		node.set_texture(texture)
		print(node)
		obj.append(node)
		obj[n].set_frame(n)
		add_child(obj[n])
	
	for x in range(5):
		for y in range(5):
			obj[frames].set_position(Vector2(y*(64/5) + pos.x, x * (64/5) + pos.y))
			frames += 1

func clear():
	frames = 0
	for n in range(25):
		remove_child(obj[n])
		obj.clear()

func explosion():
	if detonat == true:
		for j in range(VoD):
			if drops.size() < obj.size():
				var n = drops.size()
				var drop = Fragmentation.new(obj[n].get_position().x, obj[n].get_position().y)
				drop.move(randf() * 2-2, randf()*(-2)-15)
				drops.push_front(drop)
		for i in range(drops.size()):
			drops[i].move(0, GRAVITY)
			drops[i].integrate()
			obj[i].set_position(Vector2(drops[i].bounce().x, drops[i].bounce().y))
			if obj[i].get_position().x > pos.x: obj[i].rotate(rand_range(-0.1, -0.5))
			if obj[i].get_position().x < pos.x: obj[i].rotate(rand_range(0.1, 0.5))
			if obj[i].get_position().y >= pos.y: obj[i].set_rotation(0.1)
		timer += 1
		
		if drops.size() == obj.size() and timer > 200:
			#drops.clear()
			#clear()
			queue_free()
			#img()
			timer = 0
			detonat = false
			
func _ready():
	img()
	set_process_input(true)
	set_process(true)

func _process(delta):
	explosion()

func active():
	detonat = true

func change_texture(tex):
	texture = tex
