extends Node2D

# ------------
var camera2D
var is_player_initialized = false
var held_item_position

# ------------
const bomb_object = preload("res://presets/bomb/bomb.tscn")
var held_item = null

func init_player():
	is_player_initialized = true
	
	$Player.position = $PlayerSpawnLoc.position
	
	$Player.connect("player_state", self, "_on_player_grounded")
	$Player.connect("throw_item", self, "_throw_held_item")
	
	# Get camera.
	camera2D = $Player.get_node('Camera')
	
	# Item spawn point
	held_item_position = get_node("SpawnLoc")

func _on_bomb_exploded():
	camera2D.add_trauma(0.5)
	$Player.got_damage()

func _on_throwable_hit():
	camera2D.add_trauma(0.5)

func spawn_rock():
	if is_player_initialized && held_item == null:
		
		# Set held item position.
		held_item_position.position = Vector2($Player.get_position().x, $Player.get_position().y)
		
		held_item = bomb_object.instance()
		held_item.connect("exploded", self, "_on_bomb_exploded")
		
		# Add item.
		held_item_position.add_child(held_item)

func _throw_held_item(launch_position):
	if is_player_initialized:
		
		if held_item == null:
			spawn_rock()
	
		held_item.launch(launch_position)
		held_item = null

func _on_player_grounded(grounded):
		camera2D.make_camera_stable_on_jump(grounded)
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_focus_next"):
		camera2D.add_trauma(0.25)
	
func _process(delta):
	
	# Register with player HUD
	if is_player_initialized:
		$Player.get_node('Camera/HUD/HBoxContainer/TraumaBar').value = camera2D.trauma * 100
		$Player.get_node('Camera/HUD/HBoxContainer/ShakeBar').value = pow(camera2D.trauma, camera2D.trauma_power) * 100
	pass
	
# ------------
func init_controls():
	$GUI/fogg.connect("toggled", self, "on_fogg_toggle")
	$GUI/sound.connect("toggled", self, "on_sound_toggle")
	
	init_sound()
	init_shaders()
	pass
	
func on_fogg_toggle(toggle):
	game.enable_shader = toggle
	init_shaders()
	
func on_sound_toggle(toggle):
	game.enable_music = toggle
	game.enable_sound = toggle
	
	init_sound()
	
func init_shaders():
	$"Foreground 2/Fog".visible = game.enable_shader
	$"Foreground/Water".visible = game.enable_shader

# ------------
func init_sound():
	if game.enable_music:
		get_node("BackgroundMusic").play()
	else:
		get_node("BackgroundMusic").stop()
	
	if game.enable_ambience:
		get_node("Ambience").play()
	else:
		get_node("Ambience").stop()
	
func _ready():
	init_controls()
	init_sound()
	init_player()
	