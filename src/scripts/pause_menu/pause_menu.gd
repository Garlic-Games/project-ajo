class_name PauseMenu;
extends CanvasLayer;

signal opened;
signal closed;
signal restart;
@onready var settings_menu: Settings = %SettingsMenu;
@onready var exit_game_confirm_menu: ConfirmMenu = %ExitGameConfirmMenu;
@onready var main_menu_confirm_menu: ConfirmMenu = %MainMenuConfirmMenu ;
@onready var restart_confirm_menu: ConfirmMenu = %RestartConfirmMenu
@onready var recapture_mouse_button = $PanelContainer/MainPausePadding/SettingsLayout/RecaptureMouse;

@export_file("*.tscn") var main_menu_scene: String;


func _ready():
	assert(main_menu_scene, "Set a main menu scene for the pause menu");
	hide();

func toogle() -> bool:
	if visible:
		close();
	else:
		open();
	return visible;

func open() -> void:
	opened.emit();
	recapture_mouse_button.visible = OS.has_feature("web");
	show();

func close() -> void:
	closed.emit();
	hide();

func open_settings() -> void:
	settings_menu.open();

func open_restart_confirmation() -> void:
	restart_confirm_menu.open();

func open_exit_confirmation() -> void:
	exit_game_confirm_menu.open();

func open_main_confirmation() -> void:
	main_menu_confirm_menu.open();

func recapture_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	close();

func choose_exit_game(choice: bool) -> void:
	if choice:
		GameManager.exit_game();
	else:
		exit_game_confirm_menu.close();

func choose_main_menu(choice: bool) -> void:
	if choice:
		get_tree().paused = false;
		SceneLoader.load_scene(main_menu_scene);
	else:
		main_menu_confirm_menu.close();

func choose_restart_level(choice: bool) -> void:
	if choice:
		get_tree().reload_current_scene();
	else:
		restart_confirm_menu.close();
