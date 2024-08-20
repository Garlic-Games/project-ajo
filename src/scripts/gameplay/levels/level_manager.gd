extends Node3D

@export var spawners: Array[LevelSpawner];
@export var player: Player;
@export_file("*.tscn") var endgame_scene: String;
@onready var endgame_layer: CanvasLayer = $EndgameLayer
@export var music: SFXRandomPlayer = null;

func _ready() -> void:
	endgame_layer.hide();
	for child in get_children():
		if child is LevelSpawner:
			child.connect("level_ended", _next_level);
	spawners[GameManager.current_level].instantiate_level();
	_spawn_player();

func _next_level(curr_level_index: int):
	if not GameManager.next_level():
		SceneLoader.load_scene(endgame_scene)
		return;

	spawners[GameManager.current_level].instantiate_level();
	_spawn_player();

func _spawn_player():
	call_deferred("_defferred_spawn_player");

func _defferred_spawn_player():
	spawners[GameManager.current_level].spawn_player(player);
	player.plot_twisted.disconnect(_player_plot_twisted);
	player.plot_twisted.connect(_player_plot_twisted);
	_playMusic(GameManager.current_level);
	
func _player_plot_twisted():
	_playMusic(GameManager.current_level+1);
	
func reload_level():
	spawners[GameManager.current_level].spawn_player.call_deferred(player);
	_playMusic(GameManager.current_level);
	
	
func _playMusic(musicSlot: int):
	print("Playing song in slot: ", musicSlot)
	music.reproduceSingleDifferent(GameManager.songMappings[musicSlot]);
