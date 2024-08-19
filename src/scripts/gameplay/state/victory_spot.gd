@tool
class_name PlotTwistTrigger
extends GridItem

signal plot_twist;
var player: Player;
var used: bool = false;

func _on_body_entered(body: Node3D) -> void:
	player = body as Player;

func _on_body_exited(_body: Node3D) -> void:
	player = null;

func _input(event: InputEvent) -> void:
	if event.is_action_released("interact"):
		if player and not used:
			used = true;
			plot_twist.emit();
