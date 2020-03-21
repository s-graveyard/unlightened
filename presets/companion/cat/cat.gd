extends KinematicBody2D

var current_node
var direction = 1
var animation
var canCry = false

func _ready():
	set_process(true)
	current_node = get_node("Sprite")
	animation = $Sprite.get_node("anim")

func _process(delta):

	# Follow player when inside hit area.
	var current_body = get_node("Area2D").get_overlapping_bodies()

	if(current_body.size() != 0):
		for tinge in current_body:
			if(tinge.is_in_group("group_player")):
				
				canCry = true
				
				if(tinge.get_global_position().x < self.get_global_position().x - 16):
					direction = 0
				if(tinge.get_global_position().x > self.get_global_position().x + 16):
					direction = 1
			else:
				canCry = false
	
	if(direction == 0):
		current_node.set_flip_h(false)
	else:
		current_node.set_flip_h(true)
		
	if !animation.is_playing():
		if not canCry:
			animation.play("idle")
#		else:
#			animation.play("stretch")
	pass
