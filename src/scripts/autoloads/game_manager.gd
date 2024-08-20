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
const LEVEL_11 = preload("res://scenes/levels/level_11.tscn")

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
	LEVEL_11
];

var songMappings: Array[int] = [
	0, #Lvl 1
	0, #Lvl 2
	0, #Lvl 3
	0, #Lvl 4
	0, #Lvl 5
	0, #Lvl 6
	0, #Lvl 7
	0, #Lvl 8
	3, #Lvl 9 + 8 plot twist
	3, #Lvl 10
	4, #Lvl 11
];

var current_level: int = 0;
var max_level_reached: int;

func next_level():
	current_level += 1;
	if current_level > max_level_reached:
		max_level_reached = current_level;

	if levels.size() <= current_level:
		return false;
	else:
		save_game(current_level);

	return true;

func exit_game():
	if OS.has_feature("web"):
		var js_history = JavaScriptBridge.get_interface("history");
		js_history.back();
	else:
		get_tree().quit();

func save_game(level: int):
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE);
	var node_data = {"level": level};
	save_file.store_line(JSON.stringify(node_data))

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return false;
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		# Get the data from the JSON object
		var node_data = json.get_data();
		current_level = node_data["level"];
		return true;
	return false;
