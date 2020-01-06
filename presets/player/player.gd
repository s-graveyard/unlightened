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
var btn_jump = input_states.new("ui_up")
var btn_throw = input_states.new("ui_select")

# Used for loop playing animation.
func _animation(delta):
	if anim_next != anim_current:
		anim_current = anim_next
		$Sprite.get_node("anim").play(anim_next)

const step_sounds = ["StepGrassLeft","StepGrassRight"]
func play_walk():
	if game.enable_sound:
		var random_walk = get_node(step_sounds[randi() % 2])
		if grounded && not random_walk.is_playing():
			random_walk.play()
	pass

const jump_sounds = ["JumpLeft","JumpRight"]
func play_jump():
	if game.enable_sound:
		if last_action == "Jump":
			get_node("JumpLand").play()
		else:
			get_node(jump_sounds[randi() % 2]).play()
	pass
			
const damage_sounds = ["Pain1","Pain2"]
func got_damage():
	if game.enable_sound:
		var random_damage = get_node(damage_sounds[randi() % 2])
		random_damage.play()
	pass

func _physics_process(delta):
	
	if input_direction:
		direction = input_direction
		anim_next = "Move"
		
	# Left/Right movement for key press
	if btn_left.check() == 2:
		input_direction = -1
		$Sprite.flip_h = true
		play_walk()
	elif btn_right.check() == 2:
		input_direction = 1
		$Sprite.flip_h = false
		play_walk()
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
	
	speed.x = clamp(speed.x, 0, game.MAX_SPEED)

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

	if grounded:
		if last_action == "Jump":
			play_jump()
			last_action = "Idle"
			
			emit_signal("player_state", true)
			
		if btn_throw.check() == 1:
			var x_position = position.x + 100 * -direction
			emit_signal("throw_item", Vector2(x_position, position.y))

		if btn_jump.check() == 1:
			speed.y = -game.JUMP_FORCE
			anim_next = "Idle"
			grounded = false
			play_jump()
			last_action = "Jump"
	
	# Play Animation
	self._animation(delta)