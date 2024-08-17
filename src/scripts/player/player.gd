class_name Player;
extends CharacterBody3D

@export var speed = 5.0
@export var jump_velocity = 10
@export var mouse_sensitivity: float = 1;
@onready var camera: Camera3D = $Camera3D;

var wind_velocity: Vector3 = Vector3.ZERO;

var _is_editing_scenario: bool = false;
var _last_activator: BoardActivator;

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	if _is_editing_scenario:
		return;
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var real_speed = speed;
		if not is_on_floor():
			real_speed = real_speed/2;
		velocity.x = direction.x * real_speed
		velocity.z = direction.z * real_speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	if(wind_velocity):
		velocity.x += wind_velocity.x;
		velocity.y = 0.0;
		velocity.z += wind_velocity.z;

	move_and_slide()

# Called when the node enters the scene tree for the first time.
func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * (mouse_sensitivity / 100));
		camera.rotate_x(-event.relative.y * mouse_sensitivity / 100);
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70));

func set_wind_velocity(wind_velocity: Vector3):
	self.wind_velocity = wind_velocity;

func set_jump_velocity(jumper_velocity: float):
	self.velocity.y += jumper_velocity;

func handle_interact(active: bool):
	if !active:
		_is_editing_scenario = false;
		camera.current = true;
	else:
		_is_editing_scenario = true;
		camera.current = false;
