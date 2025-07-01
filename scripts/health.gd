extends Node3D
@onready var area_3d = $Area3D


func _ready():
	area_3d.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.is_blinking:return
		if body.current_health<3:
			body.get_health()
			queue_free()
