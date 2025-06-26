extends Control

@onready var start_button = $CanvasLayer/Control/StartButton
@onready var choose_button = $CanvasLayer/Control/ChooseButton
@onready var exit_button = $CanvasLayer/Control/ExitButton

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	choose_button.pressed.connect(_on_choose_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_choose_pressed():
	get_tree().change_scene_to_file("res://scenes/choose_car.tscn")

func _on_exit_pressed():
	get_tree().quit()
