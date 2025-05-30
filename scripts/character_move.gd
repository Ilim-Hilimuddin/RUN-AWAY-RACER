extends Node3D

# Kecepatan objek
var speed = 0.5

# Status apakah mobil pemain sudah terdeteksi
var player_detected = false

# Referensi ke Area3D untuk deteksi pemain
@onready var detection_area: Area3D = $DetectionArea

# Called when the node enters the scene tree for the first time.
func _ready():
	# Hubungkan signal ketika pemain masuk atau keluar dari area
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
