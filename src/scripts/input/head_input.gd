extends Node3D

@export var mouse_sensitivity: float = 1;
@onready var camera: Camera3D = $Camera3D;
# Called when the node enters the scene tree for the first time.
func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity);
		camera.rotate_x(-event.relative.y * mouse_sensitivity);
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70));
