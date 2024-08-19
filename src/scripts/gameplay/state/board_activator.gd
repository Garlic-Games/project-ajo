class_name BoardActivator;
extends Area3D

@onready var transition_camera: Camera3D = $TransitionCamera;
@export var current_grid_manager: GiantGridManager;
@export var board: Board;

var player: Player;
var is_transition_happening: bool = false;

func _on_body_entered(body: Node3D) -> void:
	player = body as Player;
	if current_grid_manager && player:
		player.notifyEnteredTableZone(true);
		current_grid_manager.item_moved.connect(player.quick_glitch)

func _on_body_exited(body: Node3D) -> void:
	if current_grid_manager && player:
		player.notifyEnteredTableZone(false);
		current_grid_manager.item_moved.disconnect(player.quick_glitch)
	player = null;

func _input(event: InputEvent) -> void:
	if event.is_action_released("interact") and not is_transition_happening:
		if player:
			var edit_mode = !board.edit_mode;
			var target_camera_transform: Transform3D;
			var tween: Tween = get_tree().create_tween();

			transition_camera.current = true;
			is_transition_happening = true;

			if edit_mode:
				player.handle_interact(edit_mode);

				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
				target_camera_transform = board.boardCamera.global_transform;
				transition_camera.global_transform = player.camera.global_transform;
			else:
				board.changeState(edit_mode)

				target_camera_transform = player.camera.global_transform;
				transition_camera.global_transform = board.boardCamera.global_transform;

			tween.tween_property(transition_camera, "global_transform", target_camera_transform, sin(PI / 2.0)) \
				 .set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT);

			tween.tween_callback(func(): end_transition(edit_mode));

func end_transition(edit_mode: bool):
	is_transition_happening = false;

	if edit_mode:
		board.boardCamera.current = true;
		board.changeState(edit_mode)
	else:
		player.camera.current = true;
		player.handle_interact(edit_mode);
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

func move_player(position: Vector3):
	if player:
		player.global_position = position;
