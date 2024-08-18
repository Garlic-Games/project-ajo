extends Node

const LEVEL_1 = preload("res://scenes/levels/level_1.tscn")
const LEVEL_2 = preload("res://scenes/levels/level_2.tscn")
const LEVEL_3 = preload("res://scenes/levels/level_3.tscn")

var levels: Array[PackedScene] = [
	LEVEL_1,
	LEVEL_2,
	LEVEL_3
];
