extends Node3D
@export var cities: Array[PackedScene]=[]

var amnt=10
var rnd=RandomNumberGenerator.new()
var offset=-10

# Called when the node enters the scene tree for the first time.
func _ready():	
	for n in amnt:
		spawnCity(n*offset)
	
func spawnCity(n):
	rnd.randomize()
	var num=rnd.randi_range(0,cities.size()-1)
	var instance=cities[num].instantiate()
	instance.position.z=n
	add_child(instance)
