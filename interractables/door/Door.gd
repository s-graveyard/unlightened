extends Area2D

signal control
signal control_select

var collide = false

var msg = game.door_dialogue_locked

var scene_dict = {
	"indoors":"res://scenes/indoors.tscn",
	"basement":"res://scenes/basement.tscn",
	"outdoors":"res://scenes/outdoors.tscn"
}

export(String) var nextscene

func _ready():
	set_process(true)
	
func _process(delta):
	if collide and Input.is_action_just_pressed("ui_select"):
		var message = null
		if nextscene == "basement" and not game.inventory.has("basement_key"):
			message = msg[randi() % msg.size()]
			
		emit_signal("control_select", scene_dict.get(nextscene), message)

func _on_Door_body_shape_entered(body_id, body, body_shape, area_shape):
	if(body.is_in_group("group_player")):
		collide = true
		
		# Who indicator 25 pixel above
		var new_position = $Door/SpawnPoint.global_position
		new_position.y -= 25
		emit_signal("control", true, new_position)

func _on_Door_body_shape_exited(body_id, body, body_shape, area_shape):
	if(body.is_in_group("group_player")):
		collide = false
		emit_signal("control", false, Vector2(0,0))
