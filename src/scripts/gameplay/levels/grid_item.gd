@tool
class_name GridItem;
extends Node3D;

@export var grid_position: Vector3i:
	set(val):
		grid_position = val;
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

@export var prefab: PackedScene;
var loaded_item: BoardItem:
	get:
		if not loaded_item:
			loaded_item = prefab.instantiate();
		return loaded_item;

func _reposition():
	position = Vector3(grid_position.x, grid_position.y, -grid_position.z) * unit_size + Vector3(offset) * unit_size + Vector3(grid_offset) * unit_size;
