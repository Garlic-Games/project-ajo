extends Node

@export var levitator: Node3D = null;
@export var levitating_amplitude : float = 0.5;
@export var levitating_period : float = 0.9;

var initial_position: float;
var animation_timer: float = 0.0;

func _ready() -> void:
	initial_position = levitator.position.y;

func _process(delta: float) -> void:
	animation_timer += delta;
	
	levitator.position.y = initial_position + levitating_amplitude * sin(2.0 * PI / levitating_period * animation_timer);

	if (animation_timer > levitating_period):
		animation_timer -= levitating_period;
