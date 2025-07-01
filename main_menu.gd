extends Control

@onready var mute = $CanvasLayer/SettingMenu/Control/VBoxContainer/MuteToggle/Mute
@onready var unmute = $CanvasLayer/SettingMenu/Control/VBoxContainer/MuteToggle/Unmute

var main_menu
var setting_menu
var high_score_menu
var credit_menu

func _ready():
	toggle_mute()
	var start_button = find_child("StartButton",true)
	var choose_button = find_child("ChooseButton",true)
	var exit_button = find_child("ExitButton",true)
	var setting_button = find_child("Setting",true)
	var highscore_button = find_child("HighScore",true)
	var back1 = find_child("Back1",true)
	var back2 = find_child("Back2",true)
	var back3 = find_child("Back3",true)
	var mute_toggle=find_child("MuteToggle",true,false)
	var volume_slider=find_child("VolumeSlider",true,false)
	var credit_button = find_child("Credit")
	main_menu = find_child("MainMenu",true)
	setting_menu=find_child("SettingMenu",true)
	high_score_menu=find_child("HighScoreMenu",true)
	credit_menu=find_child("CreditMenu")
	setting_menu.visible=false
	high_score_menu.visible=false
	credit_menu.visible=false
	main_menu.visible=true
	start_button.pressed.connect(_on_start_pressed)
	choose_button.pressed.connect(_on_choose_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	highscore_button.pressed.connect(_on_highscore_pressed)
	setting_button.pressed.connect(_on_setting_pressed.bind(false, true))
	back1.pressed.connect(_on_setting_pressed.bind(true, false))
	back2.pressed.connect(_back_to_setting)
	back3.pressed.connect(_back_to_setting)
	credit_button.pressed.connect(_to_credit)
	mute_toggle.pressed.connect(_on_music_toggled)
	volume_slider.value_changed.connect(_on_volume_changed)
	volume_slider.value = GameManager.volume

func _on_music_toggled():
	GameManager.swich_mute()
	toggle_mute()

func toggle_mute():
	mute.visible=false
	unmute.visible=false
	if not GameManager.is_mute:mute.visible=true
	else :unmute.visible=true

func _on_volume_changed(value):
	GameManager.set_volume(value)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_choose_pressed():
	get_tree().change_scene_to_file("res://scenes/choose_car.tscn")

func _on_exit_pressed():
	get_tree().quit()

func  _on_setting_pressed(s1,s2):
	main_menu.visible=s1
	setting_menu.visible=s2

func _back_to_setting():
	setting_menu.visible=true
	high_score_menu.visible=false
	credit_menu.visible=false

func _to_credit():
	setting_menu.visible=false
	credit_menu.visible=true

func _on_highscore_pressed():
	var label=find_child("HigScoreLabel")
	label.text=str(GameManager.highscore)
	high_score_menu.visible=true
