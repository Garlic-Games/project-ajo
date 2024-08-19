extends Node
@onready var plot_twist: PlotTwistTrigger = $"../Grid/PlotTwist"
const ENV_VIRTUAL = preload("res://art/backgrounds/env_virtual.tres")
@onready var world_environment: WorldEnvironment = $"../WorldEnvironment"
@onready var grid: GiantGridManager = $"../Grid"
@onready var node_3d_2: Node3D = $"../Ground2/Node3D2"
@onready var twist_grid: GiantGridManager = $"../TwistGrid"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	plot_twist.victory.connect(_execute_plot_twist)
	node_3d_2.hide()
	twist_grid.hide()


func _execute_plot_twist():
	world_environment.environment = ENV_VIRTUAL;
	grid.get_children().pick_random().is_toon = false;
	grid.get_children().pick_random().is_toon = false;
	grid.get_children().pick_random().is_toon = false;
	grid.get_children().pick_random().is_toon = false;
	node_3d_2.show()
	twist_grid.show()
