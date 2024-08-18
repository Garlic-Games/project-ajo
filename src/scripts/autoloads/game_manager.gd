extends Node

const LEVEL_1 = preload("res://scenes/levels/level_1.tscn")
const LEVEL_2 = preload("res://scenes/levels/level_2.tscn")
const LEVEL_3 = preload("res://scenes/levels/level_3.tscn")
const LEVEL_4 = preload("res://scenes/levels/level_4.tscn")
const LEVEL_5 = preload("res://scenes/levels/level_5.tscn")
const LEVEL_6 = preload("res://scenes/levels/level_6.tscn")
const LEVEL_7 = preload("res://scenes/levels/level_7.tscn")
const LEVEL_8 = preload("res://scenes/levels/level_8.tscn")
const LEVEL_9 = preload("res://scenes/levels/level_9.tscn")
const LEVEL_10 = preload("res://scenes/levels/level_10.tscn")

var levels: Array[PackedScene] = [
	LEVEL_1,
	LEVEL_2,
	LEVEL_3,
	LEVEL_4,
	LEVEL_5,
	LEVEL_6,
	LEVEL_7,
	LEVEL_8,
	LEVEL_9,
	LEVEL_10,
];

var current_level: int = 0;
var max_level_reached: int;

func next_level():
	current_level += 1;
	if current_level > max_level_reached:
		max_level_reached = current_level;

	if levels.size() <= current_level:
		return false;

	return true;
