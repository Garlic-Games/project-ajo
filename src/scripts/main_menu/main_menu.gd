extends CanvasLayer;

@onready var settings_menu: Settings = %SettingsMenu;
@onready var credits: Credits = %Credits;
@onready var loading_panel: LoadingPanel = %LoadingPanel;
@export_file("*.tscn") var gameplay_scene: String;
@onready var continueGameButton : BaseButton = $MainContainer/MainMargin/Buttons/ContinueGame;
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	assert(gameplay_scene != "", "A gameplay scene resource must be provided to main menu")

func start_game() -> void:
	GameManager.current_level = 0;
	SceneLoader.load_scene(gameplay_scene);

func continue_game() -> void:
	if GameManager.load_game():
		print("Loading level: ", GameManager.current_level)
		SceneLoader.load_scene(gameplay_scene);
	else:
		continueGameButton.text = "Error loading game"

func open_settings() -> void:
	settings_menu.open();

func open_credits() -> void:
	credits.open();

func close_game() -> void:
	GameManager.exit_game();
