class_name Board extends Node3D


signal item_moved(item: BoardItem, coords: Vector3i);


@onready var boardTable: BoardTable = $BoardTable;
@onready var boardCamera: Camera3D = $CameraPivot/EditCamera;
@onready var cameraPivot: Node3D = $CameraPivot;

#Default true for debug
var edit_mode: bool = false;
var item_follow_mouse: BoardItem = null;
var rotation_step = 90;
var camera_position = 0;

func _process(delta: float) -> void:
	if item_follow_mouse != null:
		pickupFollowMouse();
	if edit_mode:
		var scroll = 0;
		if Input.is_action_just_released("scroll_down"):
			scroll = -1;
		if Input.is_action_just_released("scroll_up"):
			scroll = 1;
		if scroll != 0:
			camera_position += scroll * rotation_step;
			position_camera();

func changeState(newState: bool):
	edit_mode = newState;
	boardCamera.current = edit_mode;
	if edit_mode:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED;
		camera_position = 0;
		cameraPivot.rotation.y = 0;
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

func position_camera():
	print("Camera degrees", camera_position);
	var tween = get_tree().create_tween();
	tween.tween_property(cameraPivot, "rotation:y", deg_to_rad(camera_position), 0.6)\
		.set_trans(Tween.TRANS_LINEAR);


func registerItem(item: BoardItem, coordX: int, coordY: int):
	boardTable.setItem(item, coordX, coordY);
	connectListeners(item);

func setSize(size: Vector2):
	boardTable.sizeX = size.x;
	boardTable.sizeY = size.y;
	boardTable.redraw();

func _ready() -> void:
	connectListeners(boardTable)


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
		if (item_follow_mouse.sizeX + tile.coordX)  > base.sizeX:
			#print("No cabe por X")
			return
		if (item_follow_mouse.sizeY + tile.coordY)  > base.sizeY:
			#print("No cabe por Y")
			return
		item_follow_mouse.coordX = tile.coordX;
		item_follow_mouse.coordY = tile.coordY;
		item_follow_mouse.onEndPickUp();
		base.setItem(item_follow_mouse, tile.coordX, tile.coordY);
		emitItemMoved(item_follow_mouse)
		item_follow_mouse = null;
	else:
		if tile.floorParent is BoardItem:
			tile.onMouseExited();
			tableItemPickedUp(tile.floorParent);

func emitItemMoved(itemToEmit: BoardItem):
	var distanceToFloor = Vector3i(0, 0, -1);
	distanceToFloor = findParentFloor(itemToEmit, distanceToFloor);
	#print("emitting item_moved ", distanceToFloor);
	item_moved.emit(itemToEmit, distanceToFloor);
	emitForChilds(itemToEmit);

func emitForChilds(itemToEmit: BoardItem):
	for each in itemToEmit.getItemChilds():
		emitItemMoved(each);

func findParentFloor(item: BoardGridBase, count: Vector3i):
	if item is BoardGridBase:
		count = Vector3i(count.x + item.coordX, count.y + item.coordY, count.z);
	if item is BoardTable:
		return count;
	return findParentFloor(findParentBoard(item.get_parent()), Vector3i(count.x, count.y, count.z +1));

func findParentBoard(item: Node3D):
	if item == null:
		return null;
	if item is BoardGridBase:
		return item;
	return findParentBoard(item.get_parent());


func pickupFollowMouse():
	var spaceState = get_world_3d().direct_space_state;
	var mousePos = get_viewport().get_mouse_position();
	var rayOrigin = boardCamera.project_ray_origin(mousePos)
	var rayEnd = rayOrigin + boardCamera.project_ray_normal(mousePos) * 2000
	var query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd);
	query.exclude = [item_follow_mouse];
	query.collision_mask = 1;
	var result = spaceState.intersect_ray(query);
	if result && result.collider is BoardFloorTile && result.collider && result.collider.global_position:
		var floorTile = result.collider as BoardFloorTile;
		var itemSize = item_follow_mouse.getSize();
		floorTile.floorParent.reparentItem(item_follow_mouse);
		item_follow_mouse.position.x = floorTile.coordX;
		item_follow_mouse.position.z = floorTile.coordY;
		item_follow_mouse.position.y = result.collider.position.y + 1.2;
	#else:
		#print(result);
