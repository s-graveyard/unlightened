extends KinematicBody2D

var current_node
var direction = 1
var speed = 100
var animation

func _ready():
	set_process(true)
	current_node = get_node("Sprite")
	animation = $Sprite.get_node("anim").play("Follow")

func _process(delta):
	
	# Follow player when inside hit area.
	var velocity = Vector2()
	var current_body = get_node("Area2D").get_overlapping_bodies()
	
	if(current_body.size() != 0):
		for tinge in current_body:
			if(tinge.is_in_group("group_player")):
				if(tinge.get_global_position().x < self.get_global_position().x - 16):
					velocity += Vector2(-1, 0)
					direction = 0
				if(tinge.get_global_position().x > self.get_global_position().x + 16):
					velocity += Vector2(1, 0)
					direction = 1
				if(tinge.get_global_position().y < self.get_global_position().y - 16):
					velocity += Vector2(0, -1)
				if(tinge.get_global_position().y > self.get_global_position().y + 16):
					velocity += Vector2(0, 1)
	
	if(direction == 0):
		current_node.set_flip_h(true)
	else:
		current_node.set_flip_h(false)
	
	# Move to desired location
	velocity = velocity.normalized() * speed * delta
	velocity = move_and_collide(velocity)
	pass