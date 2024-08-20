extends Node
@onready var plot_twist: PlotTwistTrigger = $"../Grid/PlotTwist"
const ENV_VIRTUAL: Resource = preload("res://art/backgrounds/env_virtual.tres")
@onready var world_environment: WorldEnvironment = $"../WorldEnvironment"
@onready var grid: GiantGridManager = $"../Grid"
@onready var twist_grid: GiantGridManager = $"../TwistGrid"
@onready var _1_by_1_grid_item: CSGBox3D = $"../Ground2/1by1GridItem"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	plot_twist.victory.connect(_execute_plot_twist)
	_1_by_1_grid_item.hide()
	twist_grid.hide()


func _execute_plot_twist():
	world_environment.environment = ENV_VIRTUAL;
	grid.get_children().pick_random().is_toon = false;
	grid.get_children().pick_random().is_toon = false;
	grid.get_children().pick_random().is_toon = false;
	grid.get_children().pick_random().is_toon = false;
	_1_by_1_grid_item.show()
	twist_grid.show()
