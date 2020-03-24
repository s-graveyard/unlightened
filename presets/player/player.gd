extends KinematicBody2D

signal player_state(grounded) 
signal throw_item

var input_direction = 0
var direction = 1
var speed = Vector2(0,0)
var velocity = Vector2(0,0)
var grounded = false
var last_action = "Idle"

var anim_current = ""
var anim_next = ""

var input_states = preload("res://presets/controls/inputstates.gd")
var btn_right = input_states.new("ui_right")
var btn_left = input_states.new("ui_left")

var is_running = false

# Used for loop playing animation.
func _animation(delta):
	if anim_next != anim_current:
		anim_current = anim_next
		$Body/Sprite.get_node("anim").play(anim_next)

#const step_musics = ["StepGrassLeft","StepGrassRight"]
#func play_walk():
#	var random_walk = get_node(step_musics[randi() % 2])
#	if grounded && not random_walk.is_playing():
#		random_walk.play()

const damage_musics = ["Pain1","Pain2"]
func got_damage():
	var random_damage = get_node(damage_musics[randi() % 2])
	random_damage.play()

func _physics_process(delta):
	
	if input_direction:
		direction = input_direction
		anim_next = "Run" if is_running else "Move"
		
	# Left/Right movement for key press
	if btn_left.check() == 2:
		input_direction = -1
		$Body/Sprite.flip_h = true
#		play_walk()
	elif btn_right.check() == 2:
		input_direction = 1
		$Body/Sprite.flip_h = false
#		play_walk()
	else:
		input_direction = 0
		anim_next = "Idle"
	
	# Apply speed based on direction
	if input_direction == -direction:
		speed.x /= 2
	
	# Apply acceleration and deceleration
	if input_direction:
		speed.x += game.ACCELERATION
	else:
		speed.x -= game.DECELERATION
	
	var max_clamp = game.MAX_SPEED
	
	if Input.is_action_pressed("ui_down"):
		max_clamp *= 1.5
		is_running = true
	else:
		is_running = false
		
	speed.x = clamp(speed.x, 0, max_clamp)

	# Apply Gravity
	speed.y += game.GRAVITY * delta
	
	# Limit Fall Speed
	if speed.y > game.MAX_FALL_SPEED:
		speed.y = game.MAX_FALL_SPEED
	
	velocity = Vector2(speed.x * direction, speed.y)
	var movement = move_and_collide(velocity * delta)
	
	if movement:
		speed = move_and_slide(velocity, game.FLOOR_NORMAL)
	
	if speed.y == 0:
		grounded = true

	# Play Animation
	self._animation(delta)
