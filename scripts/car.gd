extends Node3D
const LANE_DISTANCE := .5  # Jarak antar lane
const LANES := [-1, 0, 1]   # Index posisi lane
@export var lane_transition_speed: float = 10
@export var ground_snap_speed: float = 8
const SWIPE_THRESHOLD = 10
var current_lane: int = 1
var target_x: float = 1
var swipe_start_position: Vector2
var swipe_in_progress: bool = false
var ground_shape: SphereShape3D
var ground_cast: ShapeCast3D
@onready var visual_node = $cars

var current_ground_normal: Vector3 = Vector3.UP
@export var blink_duration: float = 2.0
var is_blinking = false
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@export var max_health: int = 3
var current_health: int

@onready var cars_node: Node3D = $cars
@onready var car_sedan: Node3D = $cars/Car1
@onready var car_hatchback: Node3D = $cars/Car2

func _ready():
	update_car_visibility()
	current_health = max_health
	target_x = LANES[current_lane] * LANE_DISTANCE
	var pos = global_position
	pos.x = target_x
	global_position = pos

	_start_blink()
	add_to_group("player")

	# Create ground detection shape
	ground_cast = ShapeCast3D.new()
	ground_cast.name = "GroundDetection"
	ground_cast.collision_mask = 1
	ground_cast.target_position = Vector3(0, -5.0, 0) # Set target_position instead of cast_to

	ground_shape = SphereShape3D.new()
	ground_shape.radius = .25
	ground_cast.set_shape(ground_shape)

	add_child(ground_cast)

func _input(event):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_LEFT:
				_move_left()
			KEY_RIGHT:
				_move_right()
	# Detect swipe gestures
	if event is InputEventScreenTouch:
		if event.pressed:
			swipe_start_position = event.position
			swipe_in_progress = true
		else:
			if swipe_in_progress:
				_process_swipe(swipe_start_position, event.position)
				swipe_in_progress = false

	elif event is InputEventMouseButton:
		if event.pressed:
			swipe_start_position = event.position
			swipe_in_progress = true
		else:
			if swipe_in_progress:
				_process_swipe(swipe_start_position, event.position)
				swipe_in_progress = false

func _process_swipe(start_pos: Vector2, end_pos: Vector2) -> void:
	var delta = end_pos - start_pos
	if abs(delta.x) > SWIPE_THRESHOLD and abs(delta.x) > abs(delta.y):
		if delta.x > 0:
			_move_right()
		else:
			_move_left()

func _move_left():
	if current_lane > 0:
		current_lane -= 1
		
func _move_right():
	if current_lane < LANES.size() - 1:
		current_lane += 1

func update_lane_position(delta: float) -> void:
	target_x = LANES[current_lane] * LANE_DISTANCE

	# Pindah horizontal
	var pos = position
	pos.x = lerp(pos.x, target_x, lane_transition_speed * delta)
	position = pos

	# Efek belok (tilt) di sumbu Z dan rotasi di sumbu Y
	var direction = target_x - pos.x

	# Rotasi Z untuk efek miring ke samping (tilt)
	var tilt_z = clamp(direction * 15.0, -25.0, 25.0)

	# Rotasi Y untuk efek badan mobil belok ke arah tujuan
	var tilt_y = clamp(direction * -20.0, -180.0, 90.0)

	# Gabungkan rotasi ke visual node (pastikan visual_node sudah disiapkan)
	var current_rot = visual_node.rotation_degrees
	current_rot.z = lerp(current_rot.z, tilt_z, 6.0 * delta)
	current_rot.y = lerp(current_rot.y, tilt_y, 6.0 * delta)
	visual_node.rotation_degrees = current_rot

func _process(delta: float) -> void:
	# Ground detection
	ground_cast.force_shapecast_update()
	var ground_found = false
	var collision_count = ground_cast.get_collision_count()
	var ground_position = global_position
	
	if collision_count > 0:
		# Find closest ground collision
		var closest_index = 0
		var closest_distance = global_position.distance_to(ground_cast.get_collision_point(0))
		
		for i in range(1, collision_count):
			var distance = global_position.distance_to(ground_cast.get_collision_point(i))
			if distance < closest_distance:
				closest_distance = distance
				closest_index = i
		
		# Get ground normal
		current_ground_normal = ground_cast.get_collision_normal(closest_index).normalized()
		ground_position = ground_cast.get_collision_point(closest_index)
		ground_found = true
	
	# Calculate target position and rotation
	var target_position: Vector3
	var target_rotation: Basis
	
	if ground_found:
		# Position: 1.0 units above ground along its normal
		target_position = ground_position + current_ground_normal * 0.125
		
		# Build rotation basis manually:
		# forward direction is negative Z axis of current transform
		var forward_dir = -global_transform.basis.z.normalized()
		var right_dir = forward_dir.cross(current_ground_normal).normalized()
		var up_dir = current_ground_normal
		
		target_rotation = Basis(right_dir, up_dir, -forward_dir)
	else:
		# Apply gravity when no ground is detected
		target_position = global_position - Vector3(0, 9.8 * delta, 0)
		target_rotation = global_transform.basis
	
	# Smooth movement towards target position
	var pos = global_position
	if pos.distance_to(target_position) > 0.1:
		pos = pos.lerp(target_position, ground_snap_speed * delta / max(pos.distance_to(target_position), 0))
	else:
		pos = target_position
	
	# Apply rotation smoothly
	if ground_found:
		var current_basis = global_transform.basis
		var target_basis = target_rotation
		var new_basis = current_basis.slerp(target_basis, 0.1).orthonormalized()
		global_transform = Transform3D(new_basis, pos)
	else:
		global_transform = Transform3D(global_transform.basis, pos)
	
	# Horizontal movement (lane switching)
	update_lane_position(delta)

func update_car_visibility():
	var gm = get_node_or_null("/root/GameManager")
	if not gm:
		printerr("GameManager tidak ditemukan!")
		return

	match gm.selected_car_type:
		"Sedan":
			car_sedan.visible = true
			car_hatchback.visible = false
		"Hatchback":
			car_sedan.visible = false
			car_hatchback.visible = true
		_:
			car_sedan.visible = true
			car_hatchback.visible = false
			
func _start_blink():
	is_blinking = true
	# Nonaktifkan collider saat blink
	for child in get_children():
		if child is CollisionShape3D:
			child.disabled = true
	# Mainkan animasi
	anim_player.play("blink")
	# Timer untuk mengakhiri blinking
	await get_tree().create_timer(blink_duration).timeout
	_end_blink()

func _end_blink():
	is_blinking = false
	for child in get_children():
		if child is CollisionShape3D:
			child.disabled = false
	anim_player.play("ready")
	anim_player.stop()

func take_damage():
	if is_blinking:
		return  "blink" # Jangan bisa kena damage saat blinking

	current_health -= 1
	if current_health <= 0:
		var sound_duration = 0.5
		await get_tree().create_timer(sound_duration).timeout
		get_tree().paused = true
	else:
		_start_blink()

func get_health():
	var se = $Sounds/Health
	se.play()
	current_health +=1
	
func get_coin():
	if is_blinking:return
	GameManager.add_coin(1)
	var coin_sound = $Sounds/CoinSound
	if coin_sound:
		coin_sound.play()

func get_magnet():
	if is_blinking:return
	var se = $Sounds/Magnet
	se.play()
	GameManager.get_magnet()

func get_booster():
	if is_blinking:return
	var se = $Sounds/BoosterAudio
	se.play()
	GameManager.booster()	
