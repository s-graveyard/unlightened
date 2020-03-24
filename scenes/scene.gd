extends Node2D

func init_player():
	$Player.position = $PlayerSpawnLoc.position

# ------------
func init_controls():
	$World/GUI/music.connect("toggled", self, "on_music_toggle")
	$Background/Cat.connect("control", self, "on_interaction_control")
	
	init_music()
	pass
	
func on_music_toggle(toggle):
	game.enable_ambience = toggle
	init_music()
	
func on_interaction_control(value, state, position):
	var interactionControl = $World/Control
	if state:
		interactionControl.visible = true
		position.y -= 25
		interactionControl.set_position(position)
	else:
		interactionControl.visible = false
		interactionControl.set_position(Vector2(0,0))

# ------------
func init_shaders():
	$Foreground/Water/Shader.visible = true
	
# ------------
func init_music():
	if game.enable_ambience:
		$World/Ambience.play()
	else:
		$World/Ambience.stop()
	
func _ready():
	init_controls()
	init_music()
	init_player()
	init_shaders()
	
