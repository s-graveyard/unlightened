extends Control

var prev_message = ""

func handle_select(name, message = null):
	if message == null:
		SceneManager.change_scene(name)
	else:
		self.show_message(message)

func show_message(message):
	if $Anim.is_playing():
		return
		
	$Text.text = message
	$Anim.play("Show")
		
	prev_message = message
