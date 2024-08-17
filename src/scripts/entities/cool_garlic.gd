extends Node

@export var player: Node3D = null;

@onready var garlic_head: Node3D = $Body;


func _process(delta: float) -> void:
	garlic_head.look_at(player.global_position, Vector3.UP, true);
