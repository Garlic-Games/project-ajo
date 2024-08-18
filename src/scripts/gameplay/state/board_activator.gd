class_name BoardActivator;
extends Area3D

@export var board: Board;

var player: Player;

func _on_body_entered(body: Node3D) -> void:
	player = body as Player;

func _on_body_exited(body: Node3D) -> void:
	player = null;

func _input(event: InputEvent) -> void:
	if event.is_action_released("interact"):
		if player:
			player.handle_interact(!board.edit_mode);
			board.changeState(!board.edit_mode);
