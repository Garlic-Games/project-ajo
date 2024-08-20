extends Node
@onready var plot_twist: PlotTwistTrigger = $"../Grid/PlotTwist"
const ENV_VIRTUAL: Resource = preload("res://art/backgrounds/env_virtual.tres")
var env_virt_2: Resource
@onready var world_environment: WorldEnvironment = $"../WorldEnvironment"
@onready var grid: GiantGridManager = $"../Grid"
@onready var twist_grid: GiantGridManager = $"../TwistGrid"
@onready var _1_by_1_grid_item: CSGBox3D = $"../Ground2/1by1GridItem"
@onready var green_light: DirectionalLight3D = $"../greenLight"
@onready var white_light: DirectionalLight3D = $"../WhiteLight"
@onready var speech_one: Narrator = $"../LevelNarratorController/NarratorContainer/SpeechOne"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !ENV_VIRTUAL:
		env_virt_2 = ResourceLoader.load("res://art/backgrounds/env_virtual.tres")
	else:
		env_virt_2 = ENV_VIRTUAL;
	plot_twist.victory.connect(_execute_plot_twist)
	_1_by_1_grid_item.hide()
	twist_grid.hide()
	green_light.hide()
	white_light.show()


func _execute_plot_twist():
	world_environment.environment = env_virt_2;
	grid.get_children().pick_random().is_toon = false;
	grid.get_children().pick_random().is_toon = false;
	grid.get_children().pick_random().is_toon = false;
	grid.get_children().pick_random().is_toon = false;
	_1_by_1_grid_item.show()
	twist_grid.show()
	green_light.show()
	white_light.hide()
	speech_one.play_narration();
