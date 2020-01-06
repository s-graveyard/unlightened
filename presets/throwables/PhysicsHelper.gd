extends Node

class_name PhysicsHelper

static func calculate_arc_velocity(start_point, end_point, arc_height, down_gravity = null):
		
	if down_gravity == null:
		down_gravity = game.GRAVITY

	var velocity = Vector2()
	var displacement = start_point - end_point
		
	if displacement.y > arc_height:
		var time_up = sqrt(-2 * arc_height/float(game.GRAVITY))
		var time_down = sqrt(2 * (displacement.y - arc_height) /float(game.GRAVITY))
		
		velocity.y = -sqrt(-2 * game.GRAVITY * arc_height)
		velocity.x = displacement.x / float(time_up + time_down)
		
	return velocity