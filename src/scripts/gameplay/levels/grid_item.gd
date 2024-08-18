@tool
class_name GridItem;
extends Node3D;

@export_category("Grid information")
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
@export_category("item behaviour")
@export var is_inmovible: bool;
@export var prefab: PackedScene;

var loaded_item: BoardItem:
	get:
		if not loaded_item:
			loaded_item = prefab.instantiate();
		loaded_item.item_id = name;
		loaded_item.fixed = is_inmovible;
		return loaded_item;

func _reposition():
	position = Vector3(grid_position.x, grid_position.y, -grid_position.z) * unit_size + Vector3(offset) * unit_size + Vector3(grid_offset) * unit_size;
