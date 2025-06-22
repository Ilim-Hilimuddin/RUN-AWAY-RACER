extends Node

@export var speed_increment_interval: float = 10.0  # Tiap 5 detik
@export var speed_increment: float = 0.1
@export var max_speed: float = 20.0

var time_passed: float = 0.0
var score: int = 0
var highscore: int = 0
var coin:int = 0
var distance: float = 0.0
var SPEED: float = 5.0

func _ready():
	highscore=load_highscore()
	print(highscore)

func add_coin(amount: int):
	coin += amount
	print("Skor sekarang: %d" % score)
	
	if coin % 25 == 0:
		SPEED = min(SPEED + speed_increment, max_speed)
		print("Speed meningkat karena skor: %.2f" % SPEED)


func _process(delta: float) -> void:
	time_passed += delta
	distance += SPEED * delta * 25
	score = int(distance)
	
	if time_passed >= speed_increment_interval:
		time_passed = 0.0
		SPEED = min(SPEED + speed_increment, max_speed)

func save_highscore(score):
	var file = FileAccess.open("user://highscore.save", FileAccess.WRITE)
	file.store_var(score)
	file.close()

func load_highscore():
	if FileAccess.file_exists("user://highscore.save"):
		var file = FileAccess.open("user://highscore.save", FileAccess.READ)
		var score = file.get_var()
		file.close()
		return score
	else:
		return 0  # default jika belum ada data
