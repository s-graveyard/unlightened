extends KinematicBody2D

func _ready():
	var anim = $Sprite/Anim
	anim.get_animation("Idle").set_loop(true)
	anim.play("Idle")