extends Node3D
@onready var coin_detection = $CoinDetection as Area3D
@onready var anim = find_child("AnimationPlayer", true, false)
var target: CharacterBody3D = null
@export var follow_distance: float = 5.0
@export var speed: float = 5.0

func _ready():
	anim.play("rotation")
	coin_detection.body_entered.connect(_on_coin_detection_body_entered)
	target = get_node("/root/Main/Car")

func _process(delta):
	if target and GameManager.is_magnet:
		var distance = global_transform.origin.distance_to(target.global_transform.origin)
		if distance < follow_distance:
			var direction = (target.global_transform.origin - global_transform.origin).normalized()
			global_translate(direction * speed * delta)


func _on_coin_detection_body_entered(body):
	if body.is_in_group("player"):
		if not body.is_blinking or GameManager.get_magnet:
			body.get_coin()
			queue_free()
	else:queue_free()
