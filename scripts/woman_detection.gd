extends Area3D

func _ready():
	self.body_entered.connect(self._on_player_detection_body_entered)

func _on_player_detection_body_entered(body):
	if body.is_in_group("player"):
		var status=body.is_blinking
		var crash_sound = $WomanSound
		if crash_sound and not status:
			crash_sound.play()
		body.take_damage()
