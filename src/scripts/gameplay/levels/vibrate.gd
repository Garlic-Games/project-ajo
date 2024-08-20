@tool
extends Node3D

@export var vibration_strength: float = 1;
@export var vibr_diration: float = 1;
var next_vibr = vibration_strength;
var curr_vibr = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x = position.x - next_vibr * delta;
	curr_vibr += vibration_strength * delta;
	if curr_vibr > vibration_strength * vibr_diration:
		next_vibr = -next_vibr;
		curr_vibr = 0;
