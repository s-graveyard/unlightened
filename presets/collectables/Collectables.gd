extends Area2D

signal message
signal control

export (String) var collectable_key
var interact = false

func _ready():
	set_process(true)
	if not game.enable_sound:
		$Audio.stream_paused = true

func _physics_process(delta):
	# Follow player when inside hit area.
	var current_body = get_overlapping_bodies()
	
	if(current_body.size() != 0):
		for tinge in current_body:
			if(tinge.is_in_group("group_player")):
				
				if Input.is_action_just_pressed("ui_select"):
					interact = true

	if interact:
		if not game.inventory.has(collectable_key):
			game.inventory[collectable_key] = true
			emit_signal("message", game.inventory_dialogue[collectable_key])
		else:
			emit_signal("message", game.inventory_dialogue["empty"])
#
		interact = false


func _on_Collectables_body_shape_entered(body_id, body, body_shape, area_shape):
	if(body.is_in_group("group_player")):
		var new_position = global_position
		new_position.y -= 25
		emit_signal("control", true, new_position)
		print("Enter")


func _on_Collectables_body_shape_exited(body_id, body, body_shape, area_shape):
	if(body.is_in_group("group_player")):
		interact = false
		emit_signal("control", false, Vector2(0,0))
		print("Exit")
