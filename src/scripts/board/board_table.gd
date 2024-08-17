class_name BoardTable extends BoardGridBase

@onready var tableTileRoot: Node3D = $BaseTableRoot;

@export var size: float = 0.25;


var size1x1: PackedScene = preload("res://prefabs/board/floors/round_lq_plate_1x1.tscn");
var size2x2: PackedScene = preload("res://prefabs/board/floors/round_lq_plate_2x2.tscn");
var size4x4: PackedScene = preload("res://prefabs/board/floors/round_lq_plate_4x4.tscn");
var size4x8: PackedScene = preload("res://prefabs/board/floors/round_lq_plate_4x8.tscn");


func _ready() -> void:
	super._ready();
	redraw();


func redraw() -> void:
	print("redrawing", sizeY, sizeX)
	clean();
	spawn_floor();
	spawn_grid();
	position.x = -sizeX/2;
	position.z = -sizeY/2;

func clean() -> void:
	for item in tableTileRoot.get_children():
		tableTileRoot.remove_child(item);
		item.queue_free();
	for item in gridRoot.get_children():
		gridRoot.remove_child(item);
		item.queue_free();

func spawn_floor() -> void:
	var unitsY4 = floor(sizeY / 4);
	var restY4 = sizeY % 4;
	var unitsX4 = floor(sizeX / 4);
	var restX4 = sizeX % 4;
	for ny in unitsY4:
		for nx in unitsX4:
			do_spawn_floor_tile(tableTileRoot, size4x4, nx*4, ny*4, -0.1);
	var nyOccupied = unitsY4*4;
	var nxOccupied = unitsX4*4;
	#print(unitsY4, " - ", restY4, " - ", unitsX4, " - ", restX4);
	#print(nyOccupied, " - ", nxOccupied);
	for ny in sizeY:
		for nx in sizeX:
			if ny >= nyOccupied || nx >= nxOccupied:
				do_spawn_floor_tile(tableTileRoot, size1x1, nx, ny, -0.1);
		
