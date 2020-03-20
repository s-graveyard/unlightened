extends ThrowableProjectile

signal exploded

func _ready():
	$AnimatedSprite.hide()
	
func _on_Area2D_body_entered(body):
	_on_collision(body)

func _on_collision(body):
	if body.is_in_group('group_player_body'):
		set_physics_process(false)
		
		$Sprite.hide()

		$AnimatedSprite.show()
		$AnimatedSprite.play("boom")

		emit_signal("exploded", 'group_player')

		yield($AnimatedSprite, "animation_finished")
		queue_free()
		pass
	elif body.is_in_group('group_ground'):
		set_physics_process(false)
		
		$Sprite.hide()

		$AnimatedSprite.show()
		$AnimatedSprite.play("boom")
		
		emit_signal("exploded", 'group_ground')

		yield($AnimatedSprite, "animation_finished")
		queue_free()
		pass
	pass