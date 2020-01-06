extends KinematicBody2D

class_name ThrowableProjectile

const THROW_VELOCITY = Vector2(50, 50)
var velocity = Vector2.ZERO

func _ready():
	set_physics_process(false)

func _physics_process(delta):
    velocity.y += game.GRAVITY * delta

    var collision = move_and_collide(velocity * delta)
    if collision != null: 
        _on_impact(collision.normal)

func launch(target_position):
	var temp = global_transform
	var scene = get_tree().current_scene
	get_parent().remove_child(self)
	scene.add_child(self)
	
	global_transform = temp
	
	# Set velocity
	var arc_height = target_position.y - global_position.y - 32
	arc_height = min(arc_height, -32)
	velocity = PhysicsHelper.calculate_arc_velocity(global_position, target_position, arc_height)
	
	velocity = velocity.clamped(1000)
	velocity = velocity.rotated(rand_range(-0.1, 0.1))
	
	set_physics_process(true)
	
func _on_impact(normal:Vector2):
    velocity = velocity.bounce(normal)
    velocity *= 0.5 * rand_range(-0.05, 0.05)
	
func destroy():
	queue_free()
