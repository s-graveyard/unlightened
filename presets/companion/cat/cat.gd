extends KinematicBody2D

signal control

var current_node
var direction = 1
var animation

var interact = false

func _ready():
	set_process(true)
	current_node = get_node("Sprite")
	animation = $Sprite.get_node("anim")

func _physics_process(delta):
	# Follow player when inside hit area.
	var current_body = get_node("Area2D").get_overlapping_bodies()
	
	if(current_body.size() != 0):
		for tinge in current_body:
			if(tinge.is_in_group("group_player")):
				
				if Input.is_action_just_pressed("ui_select"):
					interact = true
				
				if(tinge.get_global_position().x < self.get_global_position().x - 16):
					direction = 0
				if(tinge.get_global_position().x > self.get_global_position().x + 16):
					direction = 1

	if(direction == 0):
		current_node.set_flip_h(false)
	else:
		current_node.set_flip_h(true)

	if !animation.is_playing():
		if not interact:
			animation.play("idle")
		else:
			animation.play("stretch")
			interact = false

func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	if(body.is_in_group("group_player")):
		var new_position = global_position
		new_position.y -= 25
		emit_signal("control", true, new_position)
		
func _on_Area2D_body_shape_exited(body_id, body, body_shape, area_shape):
	if(body.is_in_group("group_player")):
		interact = false
		emit_signal("control", false, Vector2(0,0))
