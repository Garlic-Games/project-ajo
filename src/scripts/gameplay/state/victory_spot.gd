@tool
class_name VictoryGridItem
extends GridItem

signal victory;
var player: Player;
var used: bool;
func _on_body_entered(body: Node3D) -> void:
	player = body as Player;

func _on_body_exited(body: Node3D) -> void:
	player = null;

func _input(event: InputEvent) -> void:
	if event.is_action_released("interact"):
		if player and not used:
			used = true;
			victory.emit();
