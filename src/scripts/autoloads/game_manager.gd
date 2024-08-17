extends Node

enum STATE {
	main_menu,
	loading,
	playing,
}

var current_level_index: int;
var current_loaded_level: Node3D;
var next_loaded_level: Node3D;

var levels: Array[PackedScene];

signal level_finished;

func next_level(level_index: int) -> void:
	if level_index == current_level_index:
		return;

	current_level_index = level_index;
	current_loaded_level = next_loaded_level;
	if levels.size() <= current_level_index:
		return;

	next_loaded_level = levels[current_level_index].instantiate();
	get_tree().root.add_child(next_loaded_level);
