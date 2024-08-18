extends Node3D

@export var spawners: Array[LevelSpawner];
@export var player: Player;

func _ready() -> void:
	for child in get_children():
		if child is LevelSpawner:
			child.connect("level_ended", _next_level);
	spawners[GameManager.current_level].instantiate_level();
	call_deferred("_spawn_player");

func _next_level(curr_level_index: int):
	GameManager.next_level();
	spawners[GameManager.current_level].instantiate_level();
	_spawn_player();

func _spawn_player():
	spawners[GameManager.current_level].spawn_player.call_deferred(player);

func reload_level():
	spawners[GameManager.current_level].spawn_player.call_deferred(player);
