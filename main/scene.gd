extends Node2D

var indicator = load("res://interractables/indicator/Indicator.tscn")

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

	if $Background/Tower_Interior/Ladder != null:
		$Background/Tower_Interior/Ladder.connect("control", self,"on_interaction_control")
		$Background/Tower_Interior/Ladder.connect("teleport", self, "teleport_player")
	
	if $Background/Tower_Interior/Door != null:
		$Background/Tower_Interior/Door.connect("control", self, "on_interaction_control")

	if $Background/Tower/Door != null:
		$Background/Tower/Door.connect("control", self, "on_interaction_control")
# ------------
func init_controls():
	$World/GUI/music.connect("toggled", self, "on_music_toggle")
	
	init_music()
	pass
	
func on_music_toggle(toggle):
	game.enable_ambience = toggle
	init_music()
	
func on_interaction_control(state, position):
	if not state:
		for controlChild in $World/Control.get_children():
			$World/Control.remove_child(controlChild)
		return
	
	var interactionControl = indicator.instance()
	interactionControl.set_position(position)
	interactionControl.visible = true
	$World/Control.add_child(interactionControl)

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
	
