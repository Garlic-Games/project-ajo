class_name Level;
extends Node3D

signal level_ended;

@export var level_index: int;

func _victory_door_entered(body: Node3D):
	level_ended.emit();
