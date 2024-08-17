extends Node3D

@onready var trigger_area: Area3D = $JumpArea;
@onready var debug_node: Node3D = $Debug;

@export var debug_mode: bool = false;
@export var jump_velocity: float = 100.0;

func _ready() -> void:
	if not debug_mode:
		debug_node.queue_free();

	trigger_area.body_entered.connect(func(entity: Node3D): on_entity_enters_jump_area(entity));

func on_entity_enters_jump_area(entity: Node3D) -> void:
	if entity is Player:
		entity.set_jump_velocity(jump_velocity);
