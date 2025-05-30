extends Node3D

@export var coin_scene: PackedScene
@export var lanes: Array = [-0.5, 0.0, 0.5]
@export var coin_count: int = 10

var speed = 5
var lastpos = 15

func _ready():
	if randi() % 2 == 0:
		rotation.y = deg_to_rad(180)
	spawn_coins()

func _process(delta):
	position.z += speed * delta
	if position.z > lastpos:
		var level = get_parent()
		if level.has_method("spawnCity"):
			print("city")
			level.spawnCity(position.z + (level.amnt * level.offset))
		queue_free()

func spawn_coins():
	if not coin_scene:
		return
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var lane_x = lanes[rng.randi_range(0, lanes.size() - 1)]
	coin_count=rng.randi_range(3,10)
	print(coin_count)
	for i in range(coin_count):
		var coin_instance = coin_scene.instantiate()
		# Pilih jalur secara acak
		
		# Pilih posisi z acak relatif terhadap lintasan ini (misal antara 0 sampai 15)
		var spawn_z = i*.5
		# Set posisi koin relatif terhadap lintasan (local position)
		coin_instance.position = Vector3(lane_x, 0.25, spawn_z)
		add_child(coin_instance)
