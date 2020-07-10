extends Area2D

signal kill

func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	if(body.is_in_group("group_player")):
		emit_signal("kill", true)
