class_name Level;
extends Node3D

@onready var void_area: Area3D = $VoidArea;

@export var spawn_point: Marker3D

var level_player: Player;
var spawn: Node3D;
signal level_ended;

func _ready() -> void:
	void_area.body_entered.connect(func(entity: Node3D): on_player_enter_void(entity));
	
	for child in get_children():
		if child is GiantGridManager:
			child.victory.connect(_victory_reached);

func _victory_reached():
	level_ended.emit();

func spawn_player(player: Player):
	if spawn_point:
		level_player = player;
		player.global_position = spawn_point.global_position;
	else:
		print_rich("[color=red]spawn point not set for node %s[/color]" % [name])

func on_player_enter_void(entity: Node3D):
	if entity is Player:
		restart_player();

func restart_player():
	spawn_player(level_player);
