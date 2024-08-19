class_name BoardTable extends BoardGridBase

@onready var tableTileRoot: Node3D = $BaseTableRoot;

@export var size: float = 0.25;


var size1x1: PackedScene = preload("res://prefabs/board/floors/round_lq_plate_1x1.tscn");
var sizeNone1x1: PackedScene = preload("res://prefabs/board/floors/none_lq_plate_1x1.tscn");


func _ready() -> void:
	super._ready();
	redraw();


func redraw() -> void:
	print("redrawing", sizeY, sizeX)
	clean();
	spawn_floor();
	spawn_grid();
	position.x = -sizeX/2.0;
	position.z = -sizeY/2.0;

func clean() -> void:
	for item in tableTileRoot.get_children():
		tableTileRoot.remove_child(item);
		item.queue_free();
	for item in gridRoot.get_children():
		gridRoot.remove_child(item);
		item.queue_free();

func spawn_floor() -> void:
	for ny in sizeY:
		for nx in sizeX:
			var tile = size1x1;
			if _isCoordBlocked(nx, ny):
				tile = sizeNone1x1;
			do_spawn_floor_tile(tableTileRoot, tile, nx, ny, -0.1);
