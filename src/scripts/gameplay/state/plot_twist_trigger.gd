@tool
class_name PlotTwistTrigger
extends GridItem
@onready var coin_gold_2: Node3D = $"coin-gold2"

signal victory;
var player: Player;
var used: bool = false;

func _on_body_entered(body: Node3D) -> void:
	player = body as Player;
	if !used:
		player.notifyEnteredTwistZone(true);

func _on_body_exited(_body: Node3D) -> void:
	if player:
		player.notifyEnteredTwistZone(false);
	player = null;

func _input(event: InputEvent) -> void:
	if event.is_action_released("interact"):
		if player and not used:
			player.notifyEnteredTwistZone(false);
			player.quick_glitch(0.2)
			used = true;
			is_toon = false;
			coin_gold_2.hide();
			victory.emit();
