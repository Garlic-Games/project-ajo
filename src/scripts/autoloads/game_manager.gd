extends Node

enum STATE {
	main_menu,
	loading,
	playing,
	editing
}

var current_level_index: int;
var current_loaded_level: Node3D;
var next_loaded_level_index: int = -1;
var next_loaded_level: Node3D;

var levels: Array[String] = [
	"res://scenes/levels/level_1.tscn",
	"res://scenes/levels/level_2.tscn",
	"res://scenes/levels/level_3.tscn"
];
signal level_finished;

func _process(delta: float) -> void:
	if next_loaded_level_index == -1:
		return;
	var status = [];
	match(ResourceLoader.load_threaded_get_status(levels[next_loaded_level_index], status)):
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
			print("loading next level ", status[0])


func start_level(level_index: int, following_level: int) -> void:
	# we load 2 levels
	var instance = load(levels[level_index]).instantiate();
	get_tree().root.add_child.call_deferred(instance);
	current_loaded_level = instance;
	current_level_index = level_index;

	if level_index + 1 < levels.size():
		instance = load(levels[level_index + 1]).instantiate();
		get_tree().root.add_child.call_deferred(instance);


	if !following_level < 0:
		_prepare_next_level(following_level);


func next_level(level_index: int, following_level: int) -> void:
	if level_index == current_level_index:
		return;_prepare_next_level

	_intatiate_loaded_level(level_index);
	_prepare_next_level(following_level);

	current_level_index = level_index;
	current_loaded_level.queue_free();
	current_loaded_level = next_loaded_level;


func _intatiate_loaded_level(level_index: int) -> void:
	if levels.size() <= level_index:
		return;
	var next_instance = ResourceLoader.load_threaded_get(levels[level_index]).instantiate();
	get_tree().root.add_child.call_deferred(next_instance);
	next_loaded_level = next_instance;
	next_loaded_level_index = level_index;

func _prepare_next_level(level_index: int) -> void:
	if levels.size() <= level_index:
		return;
	ResourceLoader.load_threaded_request(levels[level_index]);
