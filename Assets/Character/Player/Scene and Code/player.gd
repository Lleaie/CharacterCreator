extends CharacterBody3D



const JUMP_VELOCITY = 4.5

# Stores the x/y directon the player is trying to look in
var _look := Vector2.ZERO

@export var mouse_sensitivity: float = 0.00275
@export var min_boundary: float = -80
@export var max_boundary: float = 80
@export var animation_decay: float = 20.0
@export var movement_speed: float = 5

@onready var horizontal_pivot: Node3D = $HorizontalPivot
@onready var vertical_pivot: Node3D = $HorizontalPivot/VerticalPivot
@onready var rig_pivot: Node3D = $RigPivot
@onready var rig: Node3D = $RigPivot/Rig
@onready var player_body: MeshInstance3D = $RigPivot/Rig/PlayerModel/PlayerModel/Skeleton3D/Body

# Temp variable, replace with equipped_armour at some point
@onready var outfit: MeshInstance3D = $RigPivot/Rig/PlayerModel/PlayerModel/Skeleton3D/EldwykPrisonRag

# Not Implemented Yet
#var equipped_helmet: String = ""
#var equipped_armour: String = ""
#var equipped_gauntlets: String = ""
#var equipped_boots: String = ""
#var equipped_weapon: String = ""

var player_body_mat: BaseMaterial3D = preload("res://Assets/Character/Player/Materials/Player/PlayerBody.tres")
var player_eye_mat: BaseMaterial3D = preload("res://Assets/Character/Player/Materials/Player/PlayerEyes.tres")
var player_hair_mat: BaseMaterial3D = preload("res://Assets/Character/Player/Materials/Player/PlayerHair.tres")
var player_mouth_mat: BaseMaterial3D = preload("res://Assets/Character/Player/Materials/Player/PlayerMouth.tres")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	load_character_data()

func _physics_process(delta: float) -> void:
	frame_camera_rotation()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := get_movement_direction()
	rig.update_animation_tree(direction)
	if direction:
		velocity.x = direction.x * movement_speed
		velocity.z = direction.z * movement_speed
		look_toward_direction(direction, delta)
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
		velocity.z = move_toward(velocity.z, 0, movement_speed)
	
	_rotate_step_up_separation_ray()
	move_and_slide()
	snap_down_to_stairs_check()

# Character Data
func load_character_data():
	# Stats
	load_player_stats()
	
	# Equipment
	load_equipment()
	
	# Customisation
	load_appearance()

func load_player_stats():
	pass

func load_equipment():
	pass

func load_appearance():
	# Race Settings
	
	# Set player Materials
	player_body_mat.albedo_texture = CharacterDataAutoload.player_skin
	player_hair_mat.albedo_color = CharacterDataAutoload.player_hair
	player_mouth_mat.albedo_texture = CharacterDataAutoload.player_mouth
	player_eye_mat.albedo_texture = CharacterDataAutoload.player_eyes
	
	# Set Elf Ears
	if CharacterDataAutoload.is_elf:
		player_body.set_blend_shape_value(10, 1)
	else:
		player_body.set_blend_shape_value(10, 0)
	
	# Set Blendshape Values
	
	# Body Blendshape Values
	player_body.set_blend_shape_value(3, CharacterDataAutoload.breasts)
	player_body.set_blend_shape_value(2, CharacterDataAutoload.chest_size_female)
	player_body.set_blend_shape_value(5, CharacterDataAutoload.chest_size_male)
	player_body.set_blend_shape_value(7, CharacterDataAutoload.thigh_size)
	player_body.set_blend_shape_value(8, CharacterDataAutoload.booty_size)
	player_body.set_blend_shape_value(9, CharacterDataAutoload.arm_size)
	
	# Outfit Blendshape Values
	outfit.set_blend_shape_value(3, CharacterDataAutoload.breasts)
	outfit.set_blend_shape_value(2, CharacterDataAutoload.chest_size_female)
	outfit.set_blend_shape_value(5, CharacterDataAutoload.chest_size_male)
	outfit.set_blend_shape_value(7, CharacterDataAutoload.thigh_size)
	outfit.set_blend_shape_value(8, CharacterDataAutoload.booty_size)
	outfit.set_blend_shape_value(9, CharacterDataAutoload.arm_size)


# Stair Logic
var was_on_floor: bool = false
var snapped_to_stairs_last_frame: bool = false
func snap_down_to_stairs_check():
	var did_snap: bool = false
	if not is_on_floor() and velocity.y <= 0 and (was_on_floor or snapped_to_stairs_last_frame) and $StairsBelowRayCast3D.is_colliding():
		var body_test_result = PhysicsTestMotionResult3D.new()
		var params = PhysicsTestMotionParameters3D.new()
		var max_step_down: float = -0.5
		params.from = self.global_transform
		params.motion = Vector3(0, max_step_down, 0)
		if PhysicsServer3D.body_test_motion(self.get_rid(), params, body_test_result):
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true

	was_on_floor = is_on_floor()
	snapped_to_stairs_last_frame = did_snap

@onready var _initial_separation_ray_dist = abs($StepUpSeparationRay_F.position.z)
var _last_xz_vel : Vector3 = Vector3(0,0,0)
func _rotate_step_up_separation_ray():
	var xz_vel = velocity * Vector3(1,0,1)
	
	if xz_vel.length() < 0.1:
		xz_vel = _last_xz_vel
	else:
		_last_xz_vel = xz_vel
		
	var xz_f_ray_pos = xz_vel.normalized() * _initial_separation_ray_dist
	$StepUpSeparationRay_F.global_position.x = self.global_position.x + xz_f_ray_pos.x
	$StepUpSeparationRay_F.global_position.z = self.global_position.z + xz_f_ray_pos.z

	var xz_l_ray_pos = xz_f_ray_pos.rotated(Vector3(0,1.0,0), deg_to_rad(-50))
	$StepUpSeparationRay_L.global_position.x = self.global_position.x + xz_l_ray_pos.x
	$StepUpSeparationRay_L.global_position.z = self.global_position.z + xz_l_ray_pos.z
	
	var xz_r_ray_pos = xz_f_ray_pos.rotated(Vector3(0,1.0,0), deg_to_rad(50))
	$StepUpSeparationRay_R.global_position.x = self.global_position.x + xz_r_ray_pos.x
	$StepUpSeparationRay_R.global_position.z = self.global_position.z + xz_r_ray_pos.z
	
	# To prevent character from running up walls, we do a check for how steep
	# the slope in contact with our separation rays is
	$StepUpSeparationRay_F/RayCast3D.force_raycast_update()
	$StepUpSeparationRay_L/RayCast3D.force_raycast_update()
	$StepUpSeparationRay_R/RayCast3D.force_raycast_update()
	var max_slope_ang_dot = Vector3(0,1,0).rotated(Vector3(1.0,0,0), self.floor_max_angle).dot(Vector3(0,1,0))
	var any_too_steep = false
	if $StepUpSeparationRay_F/RayCast3D.is_colliding() and $StepUpSeparationRay_F/RayCast3D.get_collision_normal().dot(Vector3(0,1,0)) < max_slope_ang_dot:
		any_too_steep = true
	if $StepUpSeparationRay_L/RayCast3D.is_colliding() and $StepUpSeparationRay_L/RayCast3D.get_collision_normal().dot(Vector3(0,1,0)) < max_slope_ang_dot:
		any_too_steep = true
	if $StepUpSeparationRay_R/RayCast3D.is_colliding() and $StepUpSeparationRay_R/RayCast3D.get_collision_normal().dot(Vector3(0,1,0)) < max_slope_ang_dot:
		any_too_steep = true
	
	$StepUpSeparationRay_F.disabled = any_too_steep
	$StepUpSeparationRay_L.disabled = any_too_steep
	$StepUpSeparationRay_R.disabled = any_too_steep

# Mouse Logic
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			_look = -event.relative * mouse_sensitivity

func get_movement_direction() -> Vector3:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var input_vector := Vector3(input_dir.x, 0, input_dir.y).normalized()
	return horizontal_pivot.global_transform.basis * input_vector

func frame_camera_rotation() -> void:
	horizontal_pivot.rotate_y(_look.x)
	vertical_pivot.rotate_x(_look.y)
	
	vertical_pivot.rotation.x = clampf(
		vertical_pivot.rotation.x, 
		deg_to_rad(min_boundary), 
		deg_to_rad(max_boundary)
		)
	
	$SmoothCameraArm.global_transform = vertical_pivot.global_transform
	_look = Vector2.ZERO

# Used to make the player model face the direction they are currently walking in
func look_toward_direction(direction: Vector3, delta) -> void:
	var target_transform := rig_pivot.global_transform.looking_at(
		rig_pivot.global_position + direction, Vector3.UP, true
	)
	# Used to smooth rotation between walking directions
	rig_pivot.global_transform = rig_pivot.global_transform.interpolate_with(
		target_transform,
		1.0 - exp(-animation_decay * delta)
	)
