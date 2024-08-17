class_name BoardTable extends Node3D

signal item_picked_up(item: BoardItem);
signal tile_clicked(item: BoardFloorTile);

@onready var tableTileRoot: Node3D = $BaseTableRoot;
@onready var gridTileRoot: Node3D = $BaseGridRoot;
@onready var baseItemsRoot: Node3D = $BaseItemsRoot;


@export var boardSizeX: int = 16 : 
	set(val): 
		boardSizeX = val;
		clean();
		redraw();
@export var boardSizeY: int = 16: 
	set(val): 
		boardSizeY = val;
		clean();
		redraw();
@export var size: float = 0.25;

var grid1x1: PackedScene = preload("res://prefabs/board/floors/grid_floor_tile.tscn");

var size1x1: PackedScene = preload("res://prefabs/board/floors/round_lq_plate_1x1.tscn");
var size2x2: PackedScene = preload("res://prefabs/board/floors/round_lq_plate_2x2.tscn");
var size4x4: PackedScene = preload("res://prefabs/board/floors/round_lq_plate_4x4.tscn");
var size4x8: PackedScene = preload("res://prefabs/board/floors/round_lq_plate_4x8.tscn");

var items: Array[BoardItem] = [];
var activeTile : BoardFloorTile = null;

func _ready() -> void:
	redraw();
	
func _process(delta: float) -> void:
	if(Input.is_action_just_released("primary_click")):
		if(activeTile != null):
			tile_clicked.emit(activeTile);
	pass;

func setItem(item: BoardItem, positionX, positionY):
	baseItemsRoot.add_child(item);
	item.position.x = positionX;
	item.position.z = positionY;
	item.position.y = 0.25;
	var callable = func():  self.onItemPickedUp(item);
	item.connectPickupJustOnce(callable);

func redraw() -> void:
	print("redrawing", boardSizeY, boardSizeX)
	spawn_floor();
	spawn_grid();
	position.x = -boardSizeX/2;
	position.z = -boardSizeY/2;
	
func clean() -> void:
	for item in tableTileRoot.get_children():
		remove_child(item);
		item.queue_free();
	for item in gridTileRoot.get_children():
		remove_child(item);
		item.queue_free();

func spawn_floor() -> void:
	var unitsY4 = floor(boardSizeY / 4);
	var restY4 = boardSizeY % 4;
	var unitsX4 = floor(boardSizeX / 4);
	var restX4 = boardSizeX % 4;
	for ny in unitsY4:
		for nx in unitsX4:
			do_spawn_floor_tile(tableTileRoot, size4x4, nx*4, ny*4, -0.1);


func spawn_grid() -> void:
	#print("Spawn grid", boardSizeX, boardSizeY, size);
	for ny in boardSizeY:
		for nx in boardSizeX:
			#print("Spawning grid on", nx, ny)
			var tile: BoardFloorTile = do_spawn_floor_tile(gridTileRoot, grid1x1, nx, ny, 0.5);
			tile.coordX = nx;
			tile.coordY = ny;
			tile.connect("mouse_entered", func(): 
				self.onTileMouseHover(tile);
				);
			tile.connect("mouse_exited", func(): 
				self.onTileMouseUnHover(tile);
				);


func do_spawn_floor_tile(
	parent: Node3D,
	tile: PackedScene, 
	offsetX: int, 
	offsetZ: int, 
	offsetY: float) -> Node3D:
	#print("Instancing", tile, offsetX, offsetZ, offsetY);
	var instance: Node3D = tile.instantiate();
	add_child(instance);
	instance.position.x = offsetX;
	instance.position.z = offsetZ;
	instance.position.y = offsetY;
	return instance;

func onTileMouseHover(tile: BoardFloorTile):
	activeTile = tile;
	
func onTileMouseUnHover(tile: BoardFloorTile):
	if activeTile == tile:
		activeTile = null;
	

func onItemPickedUp(item: BoardItem):
	item_picked_up.emit(item);
	
