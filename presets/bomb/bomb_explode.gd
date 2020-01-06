extends Area2D

signal exploded

func _ready():
	$AnimatedSprite.hide()

func _on_Bomb_body_entered(body):
	if body.is_in_group("group_player"):
		$Sprite.hide()

		$AnimatedSprite.show()
		$AnimatedSprite.play("boom")

		emit_signal("exploded")

		yield($AnimatedSprite, "animation_finished")
		queue_free()
