extends Node3D
var speed = 0.5
var player_detected = false
@onready var detection_area: Area3D = $DetectionArea

func _ready():
	detection_area.connect("body_entered", Callable(self, "_on_player_entered"))
	detection_area.connect("body_exited", Callable(self, "_on_player_exited"))

# Fungsi yang dipanggil setiap frame
func _process(delta):
	# Hanya gerakkan objek jika pemain terdeteksi
	if player_detected:
		position.z += speed * delta

# Fungsi yang dipanggil ketika pemain masuk ke area deteksi
func _on_player_entered(body: Node):
	if body.is_in_group("player"):  # Pastikan yang terdeteksi adalah mobil pemain
		player_detected = true

# Fungsi yang dipanggil ketika pemain keluar dari area deteksi
func _on_player_exited(body: Node):
	if body.is_in_group("player"):  # Pastikan yang keluar adalah mobil pemain
		player_detected = false
