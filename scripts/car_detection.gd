extends Area3D
var crash_sound

func _ready():
	self.body_entered.connect(self._on_player_detection_body_entered)
	crash_sound = find_child("CrashSound")

func _process(delta):
	pass
	
func _on_player_detection_body_entered(body):
	if body.is_in_group("player"):
		if body.is_blinking:return
		crash_sound.play()
		body.take_damage()
