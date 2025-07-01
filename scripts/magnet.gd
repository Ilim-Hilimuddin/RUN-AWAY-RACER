extends Node3D

func _ready():
	var car_detection = find_child("CarDetection", true, false)
	car_detection.body_entered.connect(_on_car_detection_body_entered)

func _on_car_detection_body_entered(body):
	if body.is_in_group("player"):
		if body.is_blinking:return
		body.get_magnet()
		queue_free()
