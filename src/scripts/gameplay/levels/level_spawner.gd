class_name LevelSpawner;
extends Marker3D

@export_range(0, 2) var level_index: int;
@export var player_spawn_position: Node3D;
@export var next_spawn: LevelSpawner;
@export var despawn: LevelSpawner;

var level: Level;

func _on_level_ended():
	if next_spawn:
		next_spawn.instantiate_level();
	if despawn:
		despawn.destroy_level();

func spawn_player(player: Player):
	player.global_position = player_spawn_position.global_position;

func instantiate_level():
	if level:
		return;
	level = GameManager.levels[level_index].instantiate() as Level;
	level.level_ended.connect(_on_level_ended);
	add_child.call_deferred(level);

func destroy_level():
	if level:
		level.queue_free();
		remove_child.call_deferred(level);
