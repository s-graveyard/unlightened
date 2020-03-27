extends Node2D

func _ready():
	init_controls()
	init_music()
	init_elements()
	init_shaders()
	
# ------------
func init_elements():
	reset_player_position()
	
	if $Background/Cat != null:
		$Background/Cat.connect("control", self, "on_interaction_control")

	if $Tower_Interior/Ladder != null:
		$Tower_Interior/Ladder.connect("control", self,"on_interaction_control")
		$Tower_Interior/Ladder.connect("teleport", self, "teleport_player")
# ------------
func init_controls():
	$World/GUI/music.connect("toggled", self, "on_music_toggle")
	
	init_music()
	pass
	
func on_music_toggle(toggle):
	game.enable_ambience = toggle
	init_music()
	
func on_interaction_control(state, position):
	var interactionControl = $World/Control
	interactionControl.visible = state
	interactionControl.set_position(position)

func teleport_player(position):
	$Player.position = position

func reset_player_position():
	$Player.position = $PlayerSpawnLoc.position

# ------------
func init_shaders():
	if $Foreground != null:
		$Foreground/Water/Shader.visible = true
	
# ------------
func init_music():
	if game.enable_ambience:
		$World/Ambience.play()
	else:
		$World/Ambience.stop()
	
