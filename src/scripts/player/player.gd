class_name Player
extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D;
@onready var glitch: TextureRect = $PlayerUI/Control/Glitch
@onready var hud: PlayerHud = $PlayerUI/Container;

@export var speed = 5.0;
@export var jump_velocity = 10;
@export var mouse_sensitivity: float = 1;

@export var default_gitch_strength: float = 0.03;
@export var quick_glitch_time: float = 0.2;

@export_group("Sounds")
@export var stepsSfx: SFXRandomPlayer = null;
@export var climbSfx: SFXRandomPlayer = null;
@export var jumpSfx: SFXRandomPlayer = null;

var wind_velocity: Vector3 = Vector3.ZERO;

var is_climbing: bool = false;
var is_first_ladder_step: bool = false;
var is_leaving_wind_area: bool = false;
var is_locked: bool = false;

var _is_editing_scenario: bool = false;
var _last_activator: BoardActivator;
var wasOnFloor = false;

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta;

	if _is_editing_scenario or is_locked:
		return;
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity;
			_jumpFeedBack();

		is_climbing = false;
		velocity += global_transform.basis.z.normalized() * 23.0;

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down");
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized();

	if is_climbing and (not is_on_floor() or is_first_ladder_step):
		if not is_on_floor():
			is_first_ladder_step = false;

		velocity = Vector3.ZERO;
		if input_dir:
			velocity.y = -input_dir.y * speed;
			if climbSfx:
				climbSfx.reproduce();
	else:
		if direction:
			var real_speed = speed;
			if not is_on_floor():
				real_speed = real_speed/3;
			velocity.x = direction.x * real_speed;
			velocity.z = direction.z * real_speed;
			if stepsSfx:
				if is_on_floor():
					_walkFeedBack();

		else:
			velocity.x = move_toward(velocity.x, 0, speed);
			velocity.z = move_toward(velocity.z, 0, speed);

		if(wind_velocity):
			velocity.x += wind_velocity.x;
			velocity.y = 0.0;
			velocity.z += wind_velocity.z;
		elif is_leaving_wind_area:
			velocity.x -= wind_velocity.x;
			velocity.z -= wind_velocity.z;
	if stepsSfx:
		if is_on_floor():
			if wasOnFloor == false:
				_landFeedBack();
			wasOnFloor = true;
		else:
			wasOnFloor = false;

	move_and_slide();

# Called when the node enters the scene tree for the first time.

var pause: bool
func _input(event):
	if is_locked:
		return;

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * (mouse_sensitivity / 100));
		camera.rotate_x(-event.relative.y * mouse_sensitivity / 100);
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70));

func set_wind_velocity(_wind_velocity: Vector3):
	self.wind_velocity = _wind_velocity;
	self.is_leaving_wind_area = true;

func set_jump_velocity(jumper_velocity: float):
	self.velocity.y += jumper_velocity;

func set_climbing_mode(active: bool):
	self.is_climbing = active;
	if active:
		self.is_first_ladder_step = true;

func handle_interact(active: bool):
	_is_editing_scenario = active;
	hud.editingBoard = active;

func _walkFeedBack():
	#TODO: Particles on floor?
	if stepsSfx:
		stepsSfx.reproduce();

func _landFeedBack():
	if stepsSfx:
		stepsSfx.reproduceAll(0.03)

func _jumpFeedBack():
	if jumpSfx:
		jumpSfx.reproduceAll(0.03)

func lock(locked: bool):
	is_locked = locked;

func quick_glitch(strength: float = default_gitch_strength):
	do_glitch(strength);
	var timer = get_tree().create_timer(quick_glitch_time);
	timer.timeout.connect(stop_glitch);

func do_glitch(strength: float = default_gitch_strength):
	glitch.material.set_shader_parameter("doeet", true);
	if strength:
		glitch.material.set_shader_parameter("shake_power", strength);


func stop_glitch():
	glitch.material.set_shader_parameter("doeet", false);

func notifyEnteredTableZone(entered: bool):
	hud.inTableArea = entered;

func notifyEnteredLvlEndZone(entered: bool):
	hud.inEndArea = entered;

func notifyEnteredTwistZone(entered: bool):
	hud.inTwistArea = entered;
