extends StaticBody3D

@onready var horizontal_pivot: Node3D = $HorizontalPivot
@onready var vertical_pivot: Node3D = $HorizontalPivot/VerticalPivot

@export var min_boundary: float = -80
@export var max_boundary: float = 80

var _look := Vector2.ZERO

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("creator_camera_left"):
		horizontal_pivot.rotate_y(-0.05)
	if Input.is_action_pressed("creator_camera_right"):
		horizontal_pivot.rotate_y(0.05)
	


	$SmoothCameraArm.global_transform = vertical_pivot.global_transform
	_look = Vector2.ZERO
