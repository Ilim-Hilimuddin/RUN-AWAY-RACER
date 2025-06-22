extends Control
@onready var heart_1 = $CanvasLayer/GameUi/HBoxContainer/VBoxContainer2/Label4/Label/HBoxContainer/Heart1
@onready var heart_2 = $CanvasLayer/GameUi/HBoxContainer/VBoxContainer2/Label4/Label/HBoxContainer/Heart2
@onready var heart_3 = $CanvasLayer/GameUi/HBoxContainer/VBoxContainer2/Label4/Label/HBoxContainer/Heart3
@onready var game_over = $CanvasLayer/GameOver
@onready var game_ui = $CanvasLayer/GameUi
@onready var high_score_label = $CanvasLayer/GameOver/HigScoreLabel
@onready var your_score = $CanvasLayer/GameOver/YourScore
@onready var score = $CanvasLayer/GameUi/HBoxContainer/VBoxContainer/UI1/Score
@onready var coin = $CanvasLayer/GameUi/HBoxContainer/VBoxContainer/UI2/coin
@onready var high_score = $CanvasLayer/GameUi/HBoxContainer/VBoxContainer/UI3/HighScore

var hearts=[]

func _ready():
	hearts = [heart_1, heart_2, heart_3]
	
func _process(delta):
	var game_manager = get_node("/root/Main/GameManager")
	var live = get_node("/root/Main/Car").current_health
	coin.text = str(game_manager.coin)
	score.text = str(game_manager.score)
	var hs=game_manager.highscore
	var sc=game_manager.score+game_manager.coin
	if sc>hs:
		game_manager.highscore=sc
		hs=sc
	high_score.text=str(hs)
	update_hearts(live)
	if live==0:
		get_tree().paused = true
		game_over.visible = true
		game_ui.visible=false
		game_manager.save_highscore(sc)
		high_score_label.text=str(hs)
		your_score.text=str(sc)	
			
func update_hearts(live):
	for i in range(hearts.size()):
		hearts[i].visible = i < live
	

	
