extends KinematicBody2D

var move_direction = 0
var velocity = Vector2(0,0)

# ==============================================================================

func apply_animation(name, reverse = false):
	if reverse: $Body/Sprite/anim.play_backwards(name)
	else: $Body/Sprite/anim.play(name)

func is_playing():
	$Body/Sprite/anim.is_playing()
# ==============================================================================

func apply_gravity(delta):
	velocity.y += game.GRAVITY * delta

# ==============================================================================

func _ready():
	if not game.enable_sound:
		$Sound.stream_paused = true

func apply_movement(delta):
	
	# Flip player based on direction
	if move_direction == -1: $Body/Sprite.flip_h = true
	elif move_direction == 1: $Body/Sprite.flip_h = false
	
	# Apply acceleration and deceleration
	if move_direction: velocity.x += game.ACCELERATION
	else: velocity.x -= game.DECELERATION
	
	var speed_clamp = game.MAX_SPEED
	
	if btn_run.check() == 2:
		speed_clamp *= 1.5
	
	# Apply speed
	velocity.x = clamp(velocity.x, 0, speed_clamp)
	
	velocity = Vector2(velocity.x * move_direction, velocity.y)
	if move_and_collide(velocity * delta):
		velocity = move_and_slide(velocity, game.FLOOR_NORMAL)
	
# ==============================================================================

var input_state = preload("res://presets/controls/InputState.gd")
var btn_right = input_state.new("ui_right")
var btn_left = input_state.new("ui_left")
var btn_run = input_state.new("ui_down")
var btn_x = input_state.new("ui_accept")

# Player should die
var is_dead = false

func die():
	is_dead = !is_dead

func is_player_dead():
	return is_dead and !is_playing()

func is_player_awakened():
	return !is_dead and !is_playing()

# Player movement direction
func handle_input():
	
	if is_dead: return
	
	# ------------------------------------------------------
	if btn_left.check() == 2: move_direction = -1
	elif btn_right.check() == 2: move_direction = 1
	else: move_direction = 0

# ==============================================================================	
