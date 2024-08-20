@tool
extends Node3D

@export var spinspeed: float;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation_degrees.y += spinspeed * delta;
