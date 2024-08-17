class_name Balancer
extends Node3D

@export var debug_mode: bool = false;
@export var balancer_state: bool = false;
@export var max_rotation_degrees: float = 7.0;
@export var swing_speed: float = 1.0;

@onready var platform: Node3D = $Platform;
@onready var player_detector: Area3D = $Platform/PlayerDetector;
@onready var debug_node: Node3D = $Debug;

var player: Player = null;
var swing_tween: Tween = null;

var max_rotation: float = 0.0;
var is_swinging: bool = false;

var platform_offset: float = 0.0;
var rotation_value: float = 0.0;

func _ready() -> void:
	if not debug_mode:
		debug_node.queue_free();
		
	max_rotation = deg_to_rad(max_rotation_degrees);

	player_detector.body_entered.connect(func(entity: Node3D): on_entity_enters_platform(entity));
	player_detector.body_exited.connect(func(entity: Node3D): on_entity_leaves_platform(entity));
		
	if balancer_state:
		rotation_value = max_rotation;
	else:
		rotation_value = -max_rotation;
	
	platform.rotation.x = rotation_value;

func _process(delta: float) -> void:
	if player and not is_swinging:
		platform_offset = to_local(player.global_position).z;
		
		if platform_offset * rotation_value < 0.0:
			var target_rotation = -signf(rotation_value) * max_rotation;
			start_swing(target_rotation);

	rotation_value = platform.rotation.x;

func start_swing(target_rotation: float) -> void:
	swing_tween = get_tree().create_tween();
	swing_tween.tween_property(platform, "rotation", Vector3(target_rotation, 0.0, 0.0), swing_speed).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT);
	swing_tween.tween_callback(func(): is_swinging = false);
	is_swinging = true;
	
func on_entity_enters_platform(entity: Node3D) -> void:
	if entity is Player:
		player = entity as Player;
	
func on_entity_leaves_platform(entity: Node3D) -> void:
	if entity is Player:
		player = null;
