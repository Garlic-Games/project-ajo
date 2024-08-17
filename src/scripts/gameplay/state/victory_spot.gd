class_name VictorySpot;
extends Area3D

@export var next_level_index: int;
@export var following_level_index: int;

func _on_body_entered(body: Node3D) -> void:
	GameManager.next_level(next_level_index, following_level_index);
