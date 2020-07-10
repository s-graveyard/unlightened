extends CanvasLayer

signal scene_changed()

onready var animation_player = $AnimationPlayer
onready var back = $Control/Black

func change_scene(path, delay = 0.2):
	
	print(path)
	# Enable fade animation.
	yield(get_tree().create_timer(delay), "timeout")
	animation_player.play("Fade")
	yield(animation_player, "animation_finished")
	
	# Change scene
	assert(get_tree().change_scene(path) == OK)
	
	# Fade out
	animation_player.play_backwards("Fade")
	yield(animation_player, "animation_finished")
	emit_signal("scene_changed")
