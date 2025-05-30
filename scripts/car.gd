extends Node3D

# Car movement script for Godot 4.3 (3D)
# Implements swipe detection to move car between three lanes on the x-axis (-.8, 0.0, .8)
# Uses ShapeCast3D for reliable ground detection on slopes

# Lane positions on the x-axis
const LANES = [-.6, 0, .6]

# Speed of lane transition (units per second)
@export var lane_transition_speed: float = 5

# Speed of vertical movement towards ground (units per second)
@export var ground_snap_speed: float = 8

# Minimum swipe distance (in pixels) to register as a valid swipe
const SWIPE_THRESHOLD = 10

# Current lane index (0 = left, 1 = center, 2 = right)
var current_lane: int = 1

# Target x position for smooth movement
var target_x: float = 1

# Variables to track swipe gesture
var swipe_start_position: Vector2
var swipe_in_progress: bool = false

# For ground detection
var ground_shape: SphereShape3D
var ground_cast: ShapeCast3D
var current_ground_normal: Vector3 = Vector3.UP

func _ready():
	# Initialize car position to center lane
	target_x = LANES[current_lane]
	var pos = global_position
	pos.x = target_x
	global_position = pos
	add_to_group("player")


	# Create ground detection shape
	ground_cast = ShapeCast3D.new()
	ground_cast.name = "GroundDetection"
	ground_cast.collision_mask = 1
	ground_cast.target_position = Vector3(0, -2.0, 0) # Set target_position instead of cast_to

	ground_shape = SphereShape3D.new()
	ground_shape.radius = 0.3
	ground_cast.set_shape(ground_shape)

	add_child(ground_cast)

func _input(event):
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
		target_x = LANES[current_lane]

func _move_right():
	if current_lane < LANES.size() - 1:
		current_lane += 1
		target_x = LANES[current_lane]

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
		pos = pos.lerp(target_position, ground_snap_speed * delta / max(pos.distance_to(target_position), 0.001))
	else:
		pos = target_position
	
	# Apply rotation smoothly
	if ground_found:
		var current_basis = global_transform.basis
		var target_basis = target_rotation
		global_transform = Transform3D(
			current_basis.slerp(target_basis, 0.1),
			pos
		)
	else:
		global_transform = Transform3D(global_transform.basis, pos)
	
	# Horizontal movement (lane switching)
	if abs(pos.x - target_x) > 0.1:
		pos.x = lerp(pos.x, target_x, lane_transition_speed * delta / max(abs(target_x - pos.x), 0))
		global_position = pos
	
	if current_lane==1:
		pos.x = lerp(pos.x,0*delta,lane_transition_speed*delta)
		global_position = pos
		
	
	# Note: Forward movement of the track should be handled separately
