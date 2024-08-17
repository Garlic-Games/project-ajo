class_name Board extends Node3D


signal item_moved(item: BoardItem, coordX: int, coordY: int);


@onready var boardTable: BoardTable = $BoardTable;
@onready var boardCamera: Camera3D = $EditCamera;


#Default true for debug
var edit_mode: bool = true; 
var item_follow_mouse: BoardItem = null;

func _process(delta: float) -> void:
	if item_follow_mouse != null:
		pickupFollowMouse();

func changeState(newState: bool): 
	edit_mode = newState;

func registerItem(item: BoardItem, coordX: int, coordY: int):
	boardTable.setItem(item, coordX, coordY);
	connectListeners(item);

func _ready() -> void:
	connectListeners(boardTable)
	var brik2x2 = preload("res://prefabs/board/items/Item2x2.tscn");
	var brik1x1 = preload("res://prefabs/board/items/Item1x1.tscn");
	var item = brik2x2.instantiate();
	registerItem(item, 2, 2);
	var item2 = brik2x2.instantiate();
	registerItem(item2, 7, 2);
	var item3 = brik1x1.instantiate();
	item3.item_id = "ASD;";
	registerItem(item3, 5, 2);

func connectListeners(target):
	target.connect("item_picked_up", tableItemPickedUp);
	target.connect("tile_clicked", func(tile): 
		self.tableTileClicked(tile, target);
		);
	

func tableItemPickedUp(item: BoardItem):
	item.onStartPickUp();
	item_follow_mouse = item;
	
func tableTileClicked(tile: BoardFloorTile, base: BoardGridBase):
	if item_follow_mouse != null:
		base.setItem(item_follow_mouse, tile.coordX, tile.coordY);
		item_moved.emit(item_follow_mouse, tile.coordX, tile.coordY);
		item_follow_mouse = null;
	
func pickupFollowMouse():
	var spaceState = get_world_3d().direct_space_state;
	var mousePos = get_viewport().get_mouse_position();
	var rayOrigin = boardCamera.project_ray_origin(mousePos)
	var rayEnd = rayOrigin + boardCamera.project_ray_normal(mousePos) * 2000
	var query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd);
	query.exclude = [item_follow_mouse];
	var result = spaceState.intersect_ray(query);
	if result && result.collider is BoardFloorTile && result.collider && result.collider.global_position:
		var rayPos = result.collider.global_position;
		var itemSize = item_follow_mouse.getSize();
		item_follow_mouse.global_position.x = rayPos.x + itemSize.x/2;
		item_follow_mouse.global_position.z = rayPos.z + itemSize.y/2;
		item_follow_mouse.global_position.y = rayPos.y + 1.2;
