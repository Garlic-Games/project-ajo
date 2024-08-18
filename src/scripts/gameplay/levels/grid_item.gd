@tool
class_name GridItem;
extends Node3D;

@export_category("Grid information")
@export var grid_position: Vector3i:
	set(val):
		grid_position = val;
		print("%s new grid position %v" % [name, grid_position])
		_reposition();

@export var offset: Vector3:
	set(val):
		offset = val;
		_reposition();

@export var grid_offset: Vector3:
	set(val):
		grid_offset = val;
		_reposition();


@export var unit_size: Vector3:
	set(val):
		unit_size = val;
		_reposition();
@export_category("item behaviour")
@export var controlled_by: BoardGridItem;
@export var is_inmovible: bool;
@export var can_construct_over: bool = true;
@export var prefab: PackedScene;

signal position_change(new_position: Vector3)

var loaded_item: BoardItem:
	get:
		var _loaded_item = prefab.instantiate() as BoardItem;
		_loaded_item.item_id = name;
		_loaded_item.fixed = is_inmovible;
		_loaded_item.conConstructOver = can_construct_over;
		return _loaded_item;

func _reposition():
	position = Vector3(grid_position.x, grid_position.y, -grid_position.z) * unit_size + Vector3(offset) * unit_size + Vector3(grid_offset) * unit_size;
	position_change.emit(global_position);

func is_controlled_by(board: BoardGridItem) -> bool:
	if not controlled_by:
		return true;
	return board.name == controlled_by.name;
