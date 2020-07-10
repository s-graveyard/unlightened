extends Node2D

var indicator = load("res://interractables/indicator/Indicator.tscn")
var dark_background = preload("res://assets/gfx/background/night.jpg")

var ambience = null

func _ready():
	init_controls()
	init_elements()
	init_shaders()
	init_music()
	
# ------------
func init_elements():
	reset_player_position()
	
	if $Background/Outdoors == null:
		$World/ParallaxBackground/ParallaxLayer/Sky.texture = dark_background
	
	if $Background/Basement != null:
		ambience	 =  load("res://assets/sfx/mystery.ogg")
	else:
		ambience =  load("res://assets/sfx/leaves_rustling.ogg")

	if $Background/Outdoors/Door != null:
		$Background/Outdoors/Door.connect("control", self, "on_interaction_control")
		$Background/Outdoors/Door.connect("control_select", self, "on_control_select")
		
	if $Background/Outdoors/Cat != null:
		$Background/Outdoors/Cat.connect("control", self, "on_interaction_control")
		$Background/Outdoors/Cat.connect("control_select", self, "on_control_select")
		
	if $Background/Indoors/Ladder != null:
		$Background/Indoors/Ladder.connect("control", self,"on_interaction_control")
		$Background/Indoors/Ladder.connect("teleport", self, "teleport_player")
	
	if $Background/Indoors/Door != null:
		$Background/Indoors/Door.connect("control", self, "on_interaction_control")
		$Background/Indoors/Door.connect("control_select", self, "on_control_select")
		
	if $Background/Indoors/Collectables != null:
		$Background/Indoors/Collectables.connect("control", self, "on_interaction_control")
		$Background/Indoors/Collectables.connect("message", self, "on_display_message")
		
	if $Background/Indoors/Door2 != null:
		$Background/Indoors/Door2.connect("control", self, "on_interaction_control")
		$Background/Indoors/Door2.connect("control_select", self, "on_control_select")
		
	if $Background/Basement/KillSwitch != null:
		$Background/Basement/KillSwitch.connect("kill", self, "kill_player")
	
# ------------
func init_controls():
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
	
func on_control_select(name, message):
	$World/Foreground/Dialogue.handle_select(name, message)
	
func on_display_message(message):
	print(message)
	$World/Foreground/Dialogue.show_message(message)

func teleport_player(position):
	$Player.position = position
	
func kill_player(state):
	$Player.die()
	$World/Foreground/Menu.visible = true

func reset_player_position():
	$Player.position = $PlayerSpawnLoc.position
	
# ------------
func init_shaders():
	
	if game.enable_shader:
		
		# Enable water shader.
		if $Foreground != null:
			$Foreground/Water/Shader.visible = true

# ------------
func init_music():
	$World/Ambience.stop()
	
	if game.enable_ambience and ambience != null:
		$World/Ambience.stream = ambience
		$World/Ambience.play()

# -------------
func init_dialogue():
	var dialog_position = $Player.position
	dialog_position.y = dialog_position.y - 64
	$World/Dialogue.position = dialog_position

