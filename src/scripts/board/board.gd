class_name Board extends Node3D


signal item_moved(item: BoardItem, coords: Vector3i, rotationDeg: Vector3);


@onready var boardTable: BoardTable = $BoardTable;
@onready var boardCamera: Camera3D = $CameraPivot/EditCamera;
@onready var cameraPivot: Node3D = $CameraPivot;

var items_dictionary: Dictionary = {};

#Default true for debug
var edit_mode: bool = false;
var item_follow_mouse: BoardItem = null;
var rotation_step = 90;
var camera_position = 0;
var activeTween: Tween = null;

func _process(delta: float) -> void:
	if item_follow_mouse != null:
		pickupFollowMouse();
		if Input.is_action_just_pressed("rotate"):
			pickupRotate();
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
	#print("Camera degrees", camera_position);
	var tween = get_tree().create_tween();
	tween.tween_property(cameraPivot, "rotation:y", deg_to_rad(camera_position), 0.6)\
		.set_trans(Tween.TRANS_LINEAR);


func registerItem(item: BoardItem, coordX: int, coordY: int):
	boardTable.setItem(item, coordX, coordY);
	if item.item_id == null:
		item.item_id = item.name;
	items_dictionary[item.item_id] = item;
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
	if !item.fixed:
		item.onStartPickUp();
		item_follow_mouse = item;

func tableTileClicked(tile: BoardFloorTile, base: BoardGridBase):
	if item_follow_mouse != null:
		if !fitsInSpace(item_follow_mouse, tile, base):
			print("No cabe!")
			return;
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

func fitsInSpace(item: BoardItem, tile: BoardFloorTile, base: BoardGridBase):
	var coordX = tile.coordX;
	var coordY = tile.coordY;
	var face: BoardItem.FacingDirection = item.facingDirection;
	var item_start_x;
	var item_end_x;
	var item_start_y;
	var item_end_y;
	match face:
		BoardItem.FacingDirection.NORTH:
			item_start_x = tile.coordX;
			item_end_x = tile.coordX + item.sizeX;
			item_start_y = tile.coordY;
			item_end_y = tile.coordY + item.sizeY;
		BoardItem.FacingDirection.SOUTH:
			item_start_x = tile.coordX;
			item_end_x = tile.coordX + item.sizeX;
			item_start_y = tile.coordY;
			item_end_y = tile.coordY - item.sizeY;
		BoardItem.FacingDirection.EAST:
			item_start_x = tile.coordX;
			item_end_x = tile.coordX + item.sizeY;
			item_start_y = tile.coordY;
			item_end_y = tile.coordY - item.sizeX;
		BoardItem.FacingDirection.WEST:
			item_start_x = tile.coordX - item.sizeX;
			item_end_x = tile.coordX;
			item_start_y = tile.coordY;
			item_end_y = tile.coordY - item.sizeY;
	print(item_start_x, " - ", item_end_x, " - ", item_start_y, " - ", item_start_y)
	if item_start_x < 0 || item_start_y < 0:
		return false;
	if item_end_x > base.sizeX || item_end_y > base.sizeY:
		return false;
	return true;

func emitItemMoved(itemToEmit: BoardItem):
	var distanceToFloor = Vector3i(0, 0, -1);
	distanceToFloor = findParentFloor(itemToEmit, distanceToFloor);
	#print("emitting item_moved ", distanceToFloor);
	item_moved.emit(itemToEmit, distanceToFloor, itemToEmit.global_rotation_degrees);
	emitForChilds(itemToEmit);

func emitForChilds(itemToEmit: BoardItem):
	for each in itemToEmit.getItemChilds():
		emitItemMoved(each);

func findParentFloor(item: BoardGridBase, count: Vector3i):
	if item == null:
		return count;
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

func pickupRotate():
	var beforeFD = item_follow_mouse.facingDirection;
	item_follow_mouse.rotateFacingDirection();

	var newFD = item_follow_mouse.facingDirection;
	print(newFD);
	if beforeFD == 270:
		var resetTween = get_tree().create_tween();
		resetTween.tween_property(item_follow_mouse, "rotation:y", deg_to_rad(-90), 0);
		resetTween.tween_callback(func(): rotateTween(newFD));
	else:
		rotateTween(newFD)


func rotateTween(newFD):
	if activeTween != null:
		activeTween.stop();
	activeTween = get_tree().create_tween();
	activeTween.tween_property(item_follow_mouse, "rotation:y", deg_to_rad(newFD), 0.2)\
		.set_trans(Tween.TRANS_LINEAR);
	activeTween.tween_callback(func(): activeTween = null);

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
