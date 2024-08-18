class_name Board extends Node3D


signal item_moved(item: BoardItem, coords: Vector3i, rotationDeg: Vector3);


@onready var boardTable: BoardTable = $BoardTable;
@onready var boardCamera: BoardCamera = $CameraPivot/SpringArm/EditCamera;
@onready var cameraPivot: Node3D = $CameraPivot;

var items_dictionary: Dictionary = {};

#Default true for debug
var edit_mode: bool = false;
var item_follow_mouse: BoardItem = null;
var activeTween: Tween = null;

func _process(delta: float) -> void:
	var events = BoardInputEvents.new();
	for key in items_dictionary:
		items_dictionary[key].processInput(events);
	boardTable.processInput(events);
	#if events.ItemsClicked.size() > 0 || events.TilesClicked.size() > 0:
		#print(events.ItemsClicked, events.TilesClicked);


	if item_follow_mouse != null:
		pickupFollowMouse(item_follow_mouse);
		if Input.is_action_just_pressed("rotate"):
			pickupRotate(item_follow_mouse);
	if events.ItemsClicked.size() > 0 && item_follow_mouse == null:
		tableItemPickedUp(events.ItemsClicked[0]);
	else:
		if events.TilesClicked.size() > 0:
			var tile = events.TilesClicked[0];
			tableTileClicked(tile);

func changeState(newState: bool):
	edit_mode = newState;
	boardCamera.changeState(newState);
	if edit_mode:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED;
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;


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
	target.connect("item_picked_up", func(item):
		tableItemPickedUp(item);
		);

func setBlockedPositions(positions: Array[Vector2i]):
	boardTable.blockedCoords = positions;


func tableItemPickedUp(item: BoardItem):
	if !item.fixed && item_follow_mouse == null:
		item.onStartPickUp();
		item_follow_mouse = item;

func tableTileClicked(tile: BoardFloorTile):
	var base: BoardGridBase = tile.itemParent;
	if item_follow_mouse != null:
		if !fitsInSpace(item_follow_mouse, tile, base):
			#print("No cabe!")
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
	var sizeX = item.sizeX - 1;
	var sizeY = item.sizeY - 1;
	var face: BoardItem.FacingDirection = item.facingDirection;
	var item_start_x;
	var item_end_x;
	var item_start_y;
	var item_end_y;
	match face:
		BoardItem.FacingDirection.NORTH:
			item_start_x = coordX;
			item_end_x = coordX + sizeX;
			item_start_y = coordY;
			item_end_y = coordY + sizeY;
		BoardItem.FacingDirection.SOUTH:
			item_start_x = coordX - sizeX;
			item_end_x = coordX;
			item_start_y = coordY;
			item_end_y = coordY - sizeY;
		BoardItem.FacingDirection.EAST:
			item_start_x = coordX;
			item_end_x = coordX + sizeX;
			item_start_y = coordY;
			item_end_y = coordY - sizeY;
		BoardItem.FacingDirection.WEST:
			item_start_x = coordX - sizeX;
			item_end_x = coordX;
			item_start_y = coordY;
			item_end_y = coordY + sizeY;
	#print(item_start_x, " - ", item_end_x, " - ", item_start_y, " - ", item_end_y)
	if item_start_x < 0 || item_start_y < 0 || item_end_x < 0 || item_end_y < 0:
		return false;
	if item_end_x >= base.sizeX || item_end_y >= base.sizeY || item_start_x >= base.sizeX || item_start_y >= base.sizeY:
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

#TODO: This can be refactored with itemParent references
func findParentFloor(item: BoardGridBase, count: Vector3i):
	if item == null:
		return count;
	if item is BoardGridBase:
		count = Vector3i(count.x + item.coordX, count.y + item.coordY, count.z);
	if item is BoardTable:
		return count;
	return findParentFloor(findParentBoard(item.get_parent()), Vector3i(count.x, count.y, count.z +1));

#TODO: This can be refactored with itemParent references
func findParentBoard(item: Node3D):
	if item == null:
		return null;
	if item is BoardGridBase:
		return item;
	return findParentBoard(item.get_parent());

func pickupRotate(item: BoardItem):
	var beforeFD = item.facingDirection;
	item.rotateFacingDirection();

	var newFD = item.facingDirection;
	#print(newFD);
	if beforeFD == 270:
		var resetTween = get_tree().create_tween();
		resetTween.tween_property(item, "rotation:y", deg_to_rad(-90), 0);
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

func pickupFollowMouse(item: BoardItem):
	var spaceState = get_world_3d().direct_space_state;
	var mousePos = get_viewport().get_mouse_position();
	var rayOrigin = boardCamera.project_ray_origin(mousePos)
	var rayEnd = rayOrigin + boardCamera.project_ray_normal(mousePos) * 2000
	var query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd);
	var exclusions = [item];
	exclusions.append_array(item.floorTiles);
	query.exclude = exclusions;
	query.collision_mask = 32;
	var result = spaceState.intersect_ray(query);
	if result && result.collider is BoardFloorTile && result.collider && result.collider.global_position:
		var floorTile = result.collider as BoardFloorTile;
		var itemSize = item.getSize();
		if item.itemParent != floorTile.floorParent:
			floorTile.floorParent.reparentItem(item);
		item.position.x = floorTile.coordX;
		item.position.z = floorTile.coordY;
		item.position.y = result.collider.position.y + 1.2;
	#else:
		#print(result);
