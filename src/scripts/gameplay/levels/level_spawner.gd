class_name LevelSpawner;
extends Marker3D

@export_range(0, 9) var level_index: int;
@export var is_last_level: bool;
@onready var player: Player = %Player

var level: Level;

signal level_ended(level_index: int);
signal last_level_ended;

func _on_level_ended():
	level_ended.emit(level_index);
	destroy_level();
	if is_last_level:
		last_level_ended.emit();

func spawn_player(player: Player):
	level.spawn_player(player);

func instantiate_level():
	if level:
		return;
	level = GameManager.levels[level_index].instantiate() as Level;
	level.level_ended.connect(_on_level_ended);
	add_child.call_deferred(level);

func destroy_level():
	if level != null && !level.is_queued_for_deletion():
		level.queue_free();
		remove_child.call_deferred(level);
