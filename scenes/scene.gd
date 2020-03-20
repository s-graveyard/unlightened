extends Node2D

func init_player():
	$Player.position = $PlayerSpawnLoc.position

# ------------
func init_controls():
	$GUI/music.connect("toggled", self, "on_music_toggle")
	
	init_music()
	pass
	
func on_music_toggle(toggle):
	game.enable_music = toggle
	
	init_music()
	
# ------------
func init_music():
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
	init_music()
	init_player()
	
