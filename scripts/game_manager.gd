extends Node

@export var speed_increment_interval: float = 10.0  # Tiap 5 detik
@export var speed_increment: float = 0.1
@export var max_speed: float = 20.0
@onready var audio_bus = AudioServer.get_bus_index("Master")

var selected_car_type: String = "Sedan"
var time_passed: float = 0.0
var score: int = 0
var highscore: int = 0
var coin:int = 0
var distance: float = 0.0
var SPEED: float = 5.0
var is_boosting: bool = false
var is_magnet: bool = false
var booster_duration: float = 5.0
var magnet_duration:float = 5.0
var timer_counter: float = 0.0
var boost_amount: float = 5.0  # seberapa cepat tambahan speed saat booster
var get_item:int = -1
var is_mute:bool=true
var volume: float = 1.0

func _ready():
	load_data()
	
func swich_mute():
	is_mute=!is_mute
	AudioServer.set_bus_mute(audio_bus,is_mute)
	save_data()

func set_volume(value: float):
	volume = clamp(value, 0.0, 1.0)
	AudioServer.set_bus_volume_db(audio_bus, linear_to_db(volume))
	save_data()
	
func add_coin(amount: int):
	coin += amount
	score += coin
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

	if is_boosting:
		timer_counter -= delta
		if timer_counter <= 0.0:
			timer_counter=0
			get_item = -1
			is_boosting = false
			SPEED = max(SPEED - boost_amount, 5.0)  # Kembali ke kecepatan sebelum boost atau minimal 5
	
	if is_magnet:
		timer_counter -= delta
		if timer_counter <= 0.0:
			timer_counter=0
			get_item = -1
			is_magnet = false
			

func save_data():
	var file = FileAccess.open("user://highscore.save", FileAccess.WRITE)
	file.store_var(highscore)
	file.store_var(selected_car_type)
	file.store_var(is_mute)
	file.store_var(volume)
	file.close()

func save_highscore(hs):
	highscore=hs
	save_data()
	
func load_data():
	if FileAccess.file_exists("user://highscore.save"):
		var file = FileAccess.open("user://highscore.save", FileAccess.READ)
		highscore = file.get_var()
		var car = file.get_var()
		var mute = file.get_var()
		var vol = file.get_var()
		if car == null:car = "Sedan"
		selected_car_type = car 
		if mute == null:mute=true
		is_mute=mute
		if vol == null:vol=1
		volume=vol
		AudioServer.set_bus_mute(audio_bus,is_mute)
		AudioServer.set_bus_volume_db(audio_bus, linear_to_db(volume))
		file.close()
	if selected_car_type == "":selected_car_type="Sedan"
	
func reset_game():
	score = 0
	coin = 0
	SPEED = 5.0
	time_passed = 0.0
	is_boosting = false
	is_magnet = false
	get_item = -1

func booster():
	if not is_boosting:
		get_item=0
		is_boosting = true
		timer_counter = booster_duration
		SPEED = min(SPEED + boost_amount, max_speed)
		print("BOOST ON! Speed: %.2f" % SPEED)

func get_magnet():
	if not is_magnet:
		get_item=1
		is_magnet=true
		timer_counter = magnet_duration

func mute_all_audio():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)

func unmute_all_audio():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)

func set_master_volume_db(db_value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db_value)
