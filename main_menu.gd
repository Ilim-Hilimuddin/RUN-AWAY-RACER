extends Control

@onready var start_button = $CanvasLayer/Control/StartButton
@onready var credits_button = $CanvasLayer/Control/CreditsButton
@onready var exit_button = $CanvasLayer/Control/ExitButton

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_credits_pressed():
	# Tampilkan layar credits
	pass

func _on_exit_pressed():
	get_tree().quit()
