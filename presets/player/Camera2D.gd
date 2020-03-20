extends Camera2D
class_name ShakeCamera2D

const LOOK_AHEAD_FACTOR = 0
const SHIFT_TRANS = Tween.TRANS_SINE
const SHIFT_EASE = Tween.EASE_OUT
const SHIFT_DURATION = 0.5

var facing = 0

onready var prev_camera_pos = get_camera_position()
onready var tween = $Tween

export var decay = 1  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 50)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

var trauma = 0.0  # Current shake strength.
var trauma_power = 3  # Trauma exponent. Use [2, 3].
onready var noise = OpenSimplexNoise.new()
var noise_y = 0

func _ready():
	
	# Initialize variables for shake
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2

func _process(delta):
	_check_facing()
	prev_camera_pos = get_camera_position()
	
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
		
func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 0.5
	
	# Using noise
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)

func add_trauma(amount):
	trauma = min(trauma + amount, 0.5)
	
func _check_facing():
	var new_facing = sign(get_camera_position().x - prev_camera_pos.x)
	if new_facing != 0 && facing != new_facing:
		facing = new_facing
		
		var target_offset = get_viewport_rect().size.x * LOOK_AHEAD_FACTOR * facing
		tween.interpolate_property(self, "position:x", position.x, target_offset, SHIFT_DURATION, SHIFT_TRANS, SHIFT_EASE)
		tween.start()

func make_camera_stable_on_jump(is_grounded):
	drag_margin_v_enabled = !is_grounded
