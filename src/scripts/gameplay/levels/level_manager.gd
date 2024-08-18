extends Node3D

@export var spawners: Array[LevelSpawner];
@export var level_index: int;
@export var player: Player;

func _ready() -> void:
	spawners[level_index].instantiate_level();
	spawners[level_index].spawn_player(player);
	if spawners.size() > level_index + 1:
		spawners[level_index + 1].instantiate_level();
