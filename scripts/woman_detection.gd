extends Area3D
@onready var player_detection = $PlayerDetection

func _ready():
	self.body_entered.connect(self._on_player_detection_body_entered)

func _process(delta):
	pass
	
func _on_player_detection_body_entered(body):
	if body.is_in_group("player"):
		var crash_sound = $WomanSound
		if crash_sound:
			crash_sound.play()
			print("Crash!")
		body.take_damage()
