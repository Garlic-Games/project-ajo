class_name BoardCamera extends Camera3D

@onready var springArm: SpringArm3D = $"..";
@onready var cameraPivot: Node3D = $"../..";
@export var xSensitivity = 60;
@export var ySensitivity = 60;
@export var rSensitivity = 120;

var edit_mode: bool = false;
var camera_position = 0;

func changeState(newState: bool):
	edit_mode = newState;
	current = edit_mode;
	if edit_mode:
		camera_position = 0;
		cameraPivot.rotation.y = 0;

func _process(delta: float) -> void:
	if edit_mode:
		var xMovement = 0;
		var yMovement = 0;
		var rMovement = 0;
		if Input.is_action_pressed("up"):
			xMovement -= xSensitivity * delta;
		if Input.is_action_pressed("down"):
			xMovement += xSensitivity * delta;
		if Input.is_action_pressed("left"):
			rMovement -= rSensitivity * delta;
		if Input.is_action_pressed("right"):
			rMovement += rSensitivity * delta;
		if Input.is_action_just_released("scroll_down"):
			yMovement += ySensitivity * delta;
		if Input.is_action_just_released("scroll_up"):
			yMovement -= ySensitivity * delta;
			
		var newY = springArm.rotation_degrees.x  + xMovement;
		springArm.rotation_degrees.x = clamp(newY, -90, 0);
		
		var newX = springArm.spring_length + yMovement;
		springArm.spring_length = clamp(newX, 7, 25);

		if rMovement != 0:
			camera_position += rMovement;
			position_camera();
		

func position_camera():
	#print("Camera degrees", camera_position);
	var tween = get_tree().create_tween();
	tween.tween_property(cameraPivot, "rotation:y", deg_to_rad(camera_position), 0.1)\
		.set_trans(Tween.TRANS_LINEAR);
