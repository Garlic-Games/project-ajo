class_name BoardGridBase extends Node3D

signal item_picked_up(item: BoardItem);

var grid1x1: PackedScene = preload("res://prefabs/board/floors/grid_floor_tile.tscn");
var gridRoot: Node3D;
var itemsRoot: Node3D;
var activeTile : BoardFloorTile = null;
var itemParent: BoardGridBase;

@export var sizeX: int = 1;
@export var sizeY: int = 1;
@export var tileOffsetY = 0.5;
@export var conConstructOver = true;
@export var blockedCoords: Array[Vector2i] = [];

var coordX = 0;
var coordY = 0;
var floorTiles: Array[BoardFloorTile] = [];

func processInput(events: BoardInputEvents) -> void:
	if(Input.is_action_just_released("primary_click")):
		#print(activeTile);
		if(activeTile != null):
			events.TilesClicked.append(activeTile);

func _ready() -> void:
	gridRoot = find_child("GridRoot");
	itemsRoot = find_child("ItemsRoot");

func spawn_grid() -> void:
	if !conConstructOver:
		return;
	#print("Spawn grid", boardSizeX, boardSizeY, size);
	for ny in sizeY:
		for nx in sizeX:
			#print("Spawning grid on", nx, ny)
			if _isCoordBlocked(nx, ny):
				print("Position %n %n blocked" % [nx, ny])
				continue;
			var tile: BoardFloorTile = do_spawn_floor_tile(gridRoot, grid1x1, nx, ny, tileOffsetY);
			tile.coordX = nx;
			tile.coordY = ny;
			tile.itemParent = self;
			tile.connect("mouse_entered", func():
				self.onTileMouseHover(tile);
				);
			tile.connect("mouse_exited", func():
				self.onTileMouseUnHover(tile);
				);
			floorTiles.append(tile);

func reparentItem(item: BoardItem):
	var parent = item.get_parent();
	if(self != item):
		if parent:
			parent.remove_child(item);
		itemsRoot.add_child(item);
		item.itemParent = self;

func setItem(item: BoardItem, positionX, positionY):
	reparentItem(item);
	item.position.x = positionX;
	item.position.z = positionY;
	item.position.y = tileOffsetY;
	#var callable = func():  self.onItemPickedUp(item);
	#item.connectPickupJustOnce(callable);

func do_spawn_floor_tile(
	parent: Node3D,
	tile: PackedScene,
	offsetX: int,
	offsetZ: int,
	offsetY: float) -> Node3D:
	#print("Instancing", tile, offsetX, offsetZ, offsetY);
	var instance: Node3D = tile.instantiate();
	parent.add_child(instance);
	instance.position.x = offsetX;
	instance.position.z = offsetZ;
	instance.position.y = offsetY;
	if instance is BoardFloorTile:
		instance.floorParent = self;
	return instance;

func onTileMouseHover(tile: BoardFloorTile):
	activeTile = tile;
	#print("hover", activeTile);

func onTileMouseUnHover(tile: BoardFloorTile):
	if activeTile == tile:
		activeTile = null;
	#print("unhover", activeTile);

func onItemPickedUp(item: BoardItem):
	item_picked_up.emit(item);

func getItemChilds() -> Array[BoardItem]:
	var ret: Array[BoardItem] = [];
	for item in itemsRoot.get_children():
		if item is BoardItem:
			ret.append(item)
	return ret;

func _isCoordBlocked(nx: int, ny: int) -> bool :
	for item in blockedCoords:
		if item.x == nx && item.y == ny:
			return true;
	return false;
