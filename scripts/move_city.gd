extends Node3D

@export var coin_scene: PackedScene
@export var lanes: Array = [-0.5, 0.0, 0.5]
@export var coin_count: int = 10

var lastpos = 15
var Coinspawner:Array = []

func _ready():
	Coinspawner = find_children("*", "Marker3D", true)
	await get_tree().process_frame
	spawn_coins()
	if randi() % 2 == 0:
		rotation.y = deg_to_rad(180)

func _process(delta):
	var game_manager = get_node("/root/Main/GameManager")
	position.z += game_manager.SPEED * delta
	if position.z > lastpos:
		var level = get_parent()
		if level.has_method("spawnCity"):
			level.spawnCity(position.z + (level.amnt * level.offset))
		queue_free()

func spawn_coins():
	if not coin_scene:
		return

	var rng = RandomNumberGenerator.new()
	rng.randomize()
	coin_count = rng.randi_range(5, 8)  # jumlah koin random antara 3 dan 5
	var sp = Coinspawner[rng.randi_range(0, Coinspawner.size() - 1)]
	
	for i in range(coin_count):
		var coin_instance = coin_scene.instantiate()
		var spawn_position = sp.transform.origin
		spawn_position.z += i * .3
		coin_instance.transform.origin = spawn_position
		add_child(coin_instance)
