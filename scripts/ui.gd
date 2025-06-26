extends Control

var hearts = []

func _ready():
	# Ambil semua node UI secara fleksibel
	var heart_1 = find_child("Heart1", true, false)
	var heart_2 = find_child("Heart2", true, false)
	var heart_3 = find_child("Heart3", true, false)
	hearts = [heart_1, heart_2, heart_3]

	var retry = find_child("Retry", true, false)
	var exit = find_child("Exit", true, false)
	retry.pressed.connect(_on_retry_pressed)
	exit.pressed.connect(_on_exit_pressed)
	

func _process(delta):
	var game_manager = get_node("/root/Main/GameManager")
	var car = get_node("/root/Main/Car")
	var live = car.current_health

	var coin_label = find_child("coin", true, false)
	var score_label = find_child("Score", true, false)
	var high_score_label_ui = find_child("HighScore", true, false)
	var high_score_result = find_child("HigScoreLabel", true, false)
	var your_score_label = find_child("YourScore", true, false)
	var game_over = find_child("GameOver", true, false)
	var game_ui = find_child("GameUi", true, false)

	# Hitung dan tampilkan skor
	var hs = game_manager.highscore
	var sc = game_manager.score + game_manager.coin

	if sc > hs:
		game_manager.highscore = sc
		hs = sc

	score_label.text = str(game_manager.score)
	coin_label.text = str(game_manager.coin)
	high_score_label_ui.text = str(hs)

	update_hearts(live)

	if live == 0:
		var game_over_sound = $GameOverSound
		if game_over_sound:
			game_over_sound.play()
		game_over.visible = true
		game_ui.visible = false
		game_manager.save_highscore(sc)
		high_score_result.text = str(hs)
		your_score_label.text = str(sc)

func update_hearts(live):
	for i in range(hearts.size()):
		hearts[i].visible = i < live

func _on_retry_pressed():
	var game_over = find_child("GameOver", true, false)
	if game_over.visible:
		get_tree().paused = false
		get_tree().reload_current_scene()

func _on_exit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	
