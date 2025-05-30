extends Node3D  # Tempelkan script ini di node parent lampu sirine

@onready var red_light = $RedLight  # Ganti dengan path node lampu merah
@onready var blue_light = $BlueLight  # Ganti dengan path node lampu biru
@onready var audio = $"../AudioStreamPlayer3D"

var timer = 0.0
var interval = 0.5  # waktu kedip dalam detik

func _process(delta):
	if not audio.playing: audio.play()
	timer += delta
	if timer >= interval:
		timer = 0
		red_light.visible = !red_light.visible
		blue_light.visible = !blue_light.visible
