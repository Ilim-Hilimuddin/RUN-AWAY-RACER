extends Control
@onready var item_panel = $CanvasLayer/GameUi/HBoxContainer/VBoxContainer/UI4/HBoxContainer/ItemPanel
var hearts = []
var icon_items = []
 
@onready var unmute = $CanvasLayer/PauseUI/MuteToggle/Unmute
@onready var mute = $CanvasLayer/PauseUI/MuteToggle/Mute

func _ready():
	toggle_mute()
	# Ambil semua node UI secara fleksibel
	var pics = find_children("Heart*","TextureRect",true)
	for pic in pics:
		hearts.append(pic)
	
	var icons = find_children("ICON*","Sprite2D",true)
	for icon in icons:
		icon_items.append(icon)

	var retry = find_child("Retry", true, false)
	var exit_buttons = find_children("Exit","Button", true)
	var pause_button = find_child("PauseButton", true, false)
	var resume = find_child("Resume", true, false)
	var mute_toggle=find_child("MuteToggle",true,false)
	var volume_slider=find_child("VolumeSlider",true,false)
	
	retry.pressed.connect(_on_retry_pressed)
	for btn in exit_buttons:
		btn.pressed.connect(_on_exit_pressed)
	resume.pressed.connect(_on_resume_pressed)
	pause_button.pressed.connect(_on_pause_button_pressed)
	mute_toggle.pressed.connect(_on_music_toggled)
	volume_slider.value_changed.connect(_on_volume_changed)
	volume_slider.value = GameManager.volume

func _on_volume_changed(value):
	GameManager.set_volume(value)

func _on_music_toggled():
	GameManager.swich_mute()
	toggle_mute()

func toggle_mute():
	mute.visible=false
	unmute.visible=false
	if not GameManager.is_mute:mute.visible=true
	else :unmute.visible=true

func _process(delta):
	var car = get_node("/root/Main/Car")
	var live = car.current_health

	var coin_label = find_child("coin", true, false)
	var score_label = find_child("Score", true, false)
	var high_score_label_ui = find_child("HighScore", true, false)
	var high_score_result = find_child("HigScoreLabel", true, false)
	var your_score_label = find_child("YourScore", true, false)
	var progress_bar = find_child("ProgressBar",true,false)
	var game_over = find_child("GameOver", true, false)
	var game_ui = find_child("GameUi", true, false)
	
	# Hitung dan tampilkan skor
	var hs = GameManager.highscore
	var sc = GameManager.score

	if sc > hs:
		GameManager.highscore = sc
		hs = sc

	score_label.text = str(GameManager.score)
	coin_label.text = str(GameManager.coin)
	high_score_label_ui.text = str(hs)
	progress_bar.value=GameManager.timer_counter
	
	var item=GameManager.get_item
	if item > -1:
		item_panel.visible=true
		for i in range(3):
			icon_items[i].visible=false
			if i==item:icon_items[i].visible=true
	else: item_panel.visible=false
	update_hearts(live)

	if live == 0:
		var game_over_sound = $GameOverSound
		if game_over_sound:
			game_over_sound.play()
		game_over.visible = true
		game_ui.visible = false
		GameManager.save_highscore(hs)
		high_score_result.text = str(hs)
		your_score_label.text = str(sc)

func update_hearts(live):
	for i in range(hearts.size()):
		hearts[i].visible = i < live

func _on_retry_pressed():
	var game_over = find_child("GameOver", true, false)
	if game_over.visible:
		GameManager.reset_game()
		get_tree().paused = false
		
		get_tree().reload_current_scene()

func _on_exit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_pause_button_pressed():
	var pause_ui = find_child("PauseUI",true,false)
	pause_ui.visible = true
	get_tree().paused = true

func _on_resume_pressed():
	var pause_ui = find_child("PauseUI",true,false)
	pause_ui.visible = false
	get_tree().paused = false
