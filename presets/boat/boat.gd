extends KinematicBody2D

func _on_Area2D_body_entered(body):
	if body.is_in_group('group_player'):
		var anim = $Sprite.get_node("Anim")
		
		anim.play("Test")
		
#		if boat.frame != 5:
#			anim.play("Test")
