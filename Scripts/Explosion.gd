extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("explosion")


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
