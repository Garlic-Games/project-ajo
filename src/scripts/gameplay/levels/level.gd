class_name Level;
extends Node3D

@export var spawn_point: Marker3D

var spawn: Node3D;
signal level_ended;

func _ready() -> void:
	for child in get_children():
		if child is GiantGridManager:
			child.victory.connect(_victory_reached);

func _victory_reached():
	level_ended.emit();

func spawn_player(player: Player):
	if spawn_point:
		player.global_position = spawn_point.global_position;
	else:
		print_rich("[color=red]spawn point not set for node %s[/color]" % [name])
