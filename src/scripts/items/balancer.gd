class_name Balancer
extends Node3D

@export var debug_mode: bool = false;
@export var balancer_state: bool = false;

@onready var pivot: Node3D = $Pivot;
@onready var platform: Node3D = $Platform;
@onready var player_detector: Area3D = $Platform/PlayerDetector;
@onready var debug_node: Node3D = $Debug;

var player_offset: float = 0.0;
var max_rotation_degrees: float = 13.0;

var rotation_value: float = 0.0;

func _ready() -> void:
	if not debug_mode:
		debug_node.queue_free();
		
	if balancer_state:
		rotation_value = deg_to_rad(max_rotation_degrees);
	else:
		rotation_value = -deg_to_rad(max_rotation_degrees);
	
	platform.rotate_x(rotation_value);

	player_detector.body_entered.connect(on_entity_enters_platform);
	player_detector.body_entered.connect(on_entity_leaves_platform);
	
func on_entity_enters_platform(entity: Node3D):
	if entity is Player:
		var player_position = entity.global_position;
	
func on_entity_leaves_platform():
	pass;
