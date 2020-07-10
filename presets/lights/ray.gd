extends Sprite

func _ready():
	$Anim.play("Jitter")
	$Anim.seek(rand_range(0.0,1.0), true)
