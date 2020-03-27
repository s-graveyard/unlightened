extends Area2D

signal control
signal teleport

var collide = false
var teleport_position = Vector2(0,0)

func _ready():
	set_process(true)
	
func _process(delta):
	if collide and Input.is_action_just_pressed("ui_select"):
		emit_signal("teleport", teleport_position)
	
func _on_Ladder_body_shape_entered(body_id, body, body_shape, area_shape):
	if(body.is_in_group("group_player")):
		collide = true
		
		var new_position = global_position
		if area_shape == 0: # Top
			new_position = $Top/SpawnPoint.global_position
			teleport_position = $Bottom/SpawnPoint.global_position
		elif area_shape == 1:
			new_position = $Bottom/SpawnPoint.global_position
			teleport_position = $Top/SpawnPoint.global_position
		
		# Who indicator 25 pixel above
		var modified_position = new_position
		modified_position.y -= 25
		emit_signal("control", true, modified_position)

func _on_Ladder_body_shape_exited(body_id, body, body_shape, area_shape):
	if(body.is_in_group("group_player")):
		collide = false
		emit_signal("control", false, Vector2(0,0))
