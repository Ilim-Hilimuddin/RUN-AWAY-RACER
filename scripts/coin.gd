extends Node3D
@onready var coin_detection = $CoinDetection as Area3D
@onready var anim = find_child("AnimationPlayer", true, false)

func _ready():
	anim.play("rotation")
	coin_detection.body_entered.connect(_on_coin_detection_body_entered)

func _on_coin_detection_body_entered(body):
	if body.is_in_group("player"):
		if body.is_blinking:return
		print("Koin diambil oleh Player!")
		var game_manager = get_node("/root/Main/GameManager")
		if game_manager:
			game_manager.add_coin(1)
		queue_free()
