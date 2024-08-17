class_name Board extends Node3D


signal item_moved(item: BoardItem, coordX: int, coordY: int);


@onready var boardTable: BoardTable = $BoardTable;
@onready var boardCamera: Camera3D = $EditCamera;

var brik2x2 = preload("res://prefabs/board/items/Item2x2.tscn");
#Default true for debug
var edit_mode:bool = true; 
var item_follow_mouse: BoardItem = null;

func _process(delta: float) -> void:
	if item_follow_mouse != null:
		var spaceState = get_world_3d().direct_space_state;
		var mousePos = get_viewport().get_mouse_position();
		var rayOrigin = boardCamera.project_ray_origin(mousePos)
		var rayEnd = rayOrigin + boardCamera.project_ray_normal(mousePos) * 2000
		var query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd);
		query.exclude = [item_follow_mouse];
		var result = spaceState.intersect_ray(query);
		if result && result.collider && result.collider.position:
			var rayPos = result.collider.position;
			var itemSize = item_follow_mouse.getSize();
			item_follow_mouse.position.x = rayPos.x + itemSize.x;
			item_follow_mouse.position.z = rayPos.z + itemSize.y;
			

func changeState(newState: bool): 
	pass;

func registerItem(item: BoardItem):
	pass;

func _ready() -> void:
	boardTable.connect("item_picked_up", tableItemPickedUp);
	boardTable.connect("tile_clicked", tableTileClicked);
	var item = brik2x2.instantiate();
	boardTable.setItem(item, 2, 2);
	var item2 = brik2x2.instantiate();
	boardTable.setItem(item2, 7, 2);

func tableItemPickedUp(item: BoardItem):
	item.onStartPickUp();
	item_follow_mouse = item;
	item.position.y = 1.2;
	
func tableTileClicked(tile: BoardFloorTile):
	if item_follow_mouse != null:
		boardTable.setItem(item_follow_mouse, tile.coordX, tile.coordY);
		item_moved.emit(item_follow_mouse, tile.coordX, tile.coordY);
		item_follow_mouse = null;
	
