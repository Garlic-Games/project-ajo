extends Node3D

@export var level_index: int;
@export var following_level_index: int;

func _ready() -> void:
	GameManager.start_level(level_index, following_level_index);
