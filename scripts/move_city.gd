extends Node3D

@export var coin_scene: PackedScene
@export var col_item: Array[PackedScene]
@export var lanes: Array = [-0.5, 0.0, 0.5]
@export var coin_count: int = 10

var lastpos = 15
var Coinspawner:Array = []
var ItemSpawner:Array=[]

func _ready():
	Coinspawner = find_children("pos*", "Marker3D", true)
	ItemSpawner = find_children("Colpos*","Marker3D",true)
	await get_tree().process_frame
	spawn_coins()
	if ItemSpawner:
		spawn_item()
		
	if randi() % 2 == 0:
		rotation.y = deg_to_rad(180)

func _process(delta):
	position.z += GameManager.SPEED * delta
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
	coin_count = rng.randi_range(3, 5)  # jumlah koin random antara 3 dan 5
	var sp = Coinspawner[rng.randi_range(0, Coinspawner.size() - 1)]
	
	for i in range(coin_count):
		var coin_instance = coin_scene.instantiate()
		var spawn_position = sp.transform.origin
		spawn_position.z += i * 0.4
		coin_instance.transform.origin = spawn_position
		add_child(coin_instance)

func spawn_item():
	if not col_item:return
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var item = rng.randi_range(0, col_item.size()-1)
	var sp = ItemSpawner[rng.randi_range(0, ItemSpawner.size() - 1)]
	var item_instance = col_item[item].instantiate()
	var spawn_position = sp.transform.origin
	item_instance.transform.origin = spawn_position
	add_child(item_instance)
	
	
