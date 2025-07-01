extends Node3D
@onready var car_detection = $CarDetection

func _ready():
	car_detection.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.get_booster()
		queue_free()
