@tool
class_name  GiantGridManager;
extends Node3D

@export var board: Board;
@export var grid_size: Vector2i;
@export var cell_size: float;
@export var offset: Vector3:
	set(val):
		offset = val;
		_readjust_positions();

var pieces: Dictionary = {};

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		return;
	_register_children();
	if board:
		board.setSize(grid_size);
		board.item_moved.connect(_children_moved);
	_readjust_positions();

func _children_moved(item: BoardItem, coords: Vector3i):
	var piece = pieces.get(item.item_id) as GridItem;
	if not piece:
		return;
	piece.grid_position = Vector3i(coords.y, coords.z, coords.x);

func _register_children():
	for item in get_children():
		var gi = item as GridItem;
		pieces.get_or_add(item.name, item);
		if board:
			board.registerItem(gi.loaded_item, gi.grid_position.z, gi.grid_position.x);

func _readjust_positions():
	for item in get_children():
		var gi = item as GridItem;
		gi.grid_offset = offset;
