extends Node

const LEVEL_1 = preload("res://scenes/levels/level_1.tscn")
const LEVEL_2 = preload("res://scenes/levels/level_2.tscn")
const LEVEL_3 = preload("res://scenes/levels/level_3.tscn")

var levels: Array[PackedScene] = [
	LEVEL_1,
	LEVEL_2,
	LEVEL_3
];

var current_level: int;
var max_level_reached: int;

func next_level():
	current_level += 1;
	if current_level > max_level_reached:
		max_level_reached = current_level;

	if levels.size() <= current_level:
		print("yay last level")
		return;
