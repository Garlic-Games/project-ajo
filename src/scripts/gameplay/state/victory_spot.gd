@tool
class_name VictoryGridItem
extends GridItem

@export var glitch_strength: float = 0.03

signal victory;
var player: Player;
var used: bool = false;

func _on_body_entered(body: Node3D) -> void:
	player = body as Player;
	player.notifyEnteredLvlEndZone(true);

func _on_body_exited(_body: Node3D) -> void:
	if player:
		player.notifyEnteredLvlEndZone(false);
	player = null;

func _input(event: InputEvent) -> void:
	if event.is_action_released("interact"):
		if player and not used:
			used = true;
			player.quick_glitch(glitch_strength)
			victory.emit();
