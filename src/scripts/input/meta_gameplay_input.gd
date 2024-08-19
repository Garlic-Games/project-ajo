extends Node

@export var pause_menu: PauseMenu;

func _ready():
	assert(pause_menu, "Pause menu panel not assigned to metagameplay input");
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	if pause_menu:
		pause_menu.closed.connect(_unpause_game);
		pause_menu.opened.connect(_pause_game);

func _unpause_game():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	get_tree().paused = false


func _pause_game():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	get_tree().paused = true


func _input(event: InputEvent):
	if event.is_action_pressed("pause"):
		if !pause_menu:
			return;
		pause_menu.toogle();
