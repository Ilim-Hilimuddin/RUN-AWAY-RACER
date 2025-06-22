extends Node3D

@export var coin_scene: PackedScene
@export var lanes: Array = [-0.5, 0.0, 0.5]
@export var spawn_interval_z: float = 5.0

var player_node: Node3D
var last_spawn_z: float = 0.0

func _ready():
	# Ganti dengan path node mobil Anda, sesuaikan nama node mobil di scene utama
	player_node = get_parent().get_node("Car")
	if player_node:
		last_spawn_z = player_node.global_position.z

func _process(delta: float) -> void:
	if not player_node:
		return
	
	var player_z = player_node.global_position.z
	
	# Spawn koin jika sudah melewati jarak interval spawn dari spawn terakhir
	if player_z < last_spawn_z - spawn_interval_z:
		spawn_coin(player_z - spawn_interval_z)
		last_spawn_z -= spawn_interval_z
	spawn_coin(player_z-spawn_interval_z)

func spawn_coin(spawn_z: float) -> void:
	var coin_instance = coin_scene.instantiate()
	
	var lane_x = lanes[randi() % lanes.size()]
	
	coin_instance.global_position = Vector3(lane_x, 0.5, spawn_z)
	add_child(coin_instance)
