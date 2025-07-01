extends Control

@onready var sedan_button = $HBoxContainer/VBoxContainer/SedanButton
@onready var hatchback_button = $HBoxContainer/VBoxContainer2/HatchbackButton
@onready var back_button = $BackButton

var selected_car: String = "Sedan"

func _ready():
	selected_car = GameManager.selected_car_type
	select_car(selected_car)
	sedan_button.pressed.connect(_on_sedan_pressed)
	hatchback_button.pressed.connect(_on_hatchback_pressed)
	back_button.pressed.connect(_on_back_pressed)

func _on_sedan_pressed():
	select_car("Sedan")

func _on_hatchback_pressed():
	select_car("Hatchback")
	
func select_car(car_type):
	selected_car = car_type
	$Label.text = "Selected: %s" % car_type
	GameManager.selected_car_type = car_type

func _on_back_pressed():
	GameManager.save_data()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
