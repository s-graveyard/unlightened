extends StateMachine

# ==============================================================================

func _ready():
	add_state("idle")
	add_state("die")
	add_state("walk")
	add_state("run") 
	call_deferred("set_state", states.idle)

# ==============================================================================
func _get_transition(delta):
	match state:
		states.walk:
			if abs(parent.velocity.x) > game.MAX_SPEED:
				return states.run
			elif parent.velocity.x == 0:
				return states.idle
			elif parent.is_player_dead():
				return states.die
		states.run:
			if abs(parent.velocity.x) > 0 and abs(parent.velocity.x) <= game.MAX_SPEED:
				return states.walk
			elif parent.velocity.x == 0:
				return states.idle
			elif parent.is_player_dead():
				return states.die
		states.idle:
			if abs(parent.velocity.x) > 0 and abs(parent.velocity.x) <= game.MAX_SPEED:
				return states.walk
			elif abs(parent.velocity.x) > game.MAX_SPEED:
				return states.run
			elif parent.is_player_dead():
				return states.die
		states.die:
			if !parent.is_player_dead():
				return states.idle
	return null
 
# ==============================================================================

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			if old_state == states.die: parent.apply_animation("Fall", true)
			else: parent.apply_animation("Idle")
		states.die:
			parent.apply_animation("Fall")
		states.walk:
			parent.apply_animation("Move")
		states.run:
			parent.apply_animation("Run")
	pass

# ==============================================================================

func _exit_state(old_state, new_state):
	pass

# ==============================================================================

func _state_logic(delta):
	parent.apply_gravity(delta)
	parent.handle_input()
		
	# Don't apply any movement if player is dead
	if state != states.die:
		parent.apply_movement(delta)

# ==============================================================================
