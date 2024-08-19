class_name BoardItem extends BoardGridBase

enum FacingDirection {NORTH = 0, EAST = 90, SOUTH = 180, WEST = 270}

@onready var arrowResource = preload("res://art/models/kenney_brick-kit/mix/Arrow.tscn");
@export var color = 0;
@export var fixed = false;

var facingDirection = FacingDirection.NORTH;

var meshScene: Node3D;
var meshInstance: MeshInstance3D;
var arrowInstance;

var item_id = null;

var _selected = false;
var _picked_up = false;

var positionOnPickup: Vector3;

func processInput(events: BoardInputEvents) -> void:
	super.processInput(events);
	if(Input.is_action_just_released("primary_click")):
		if _selected:
			events.ItemsClicked.append(self);

func redraw() -> void:
	meshScene.scale.y =  meshScene.scale.y * sizeY;
	spawn_grid();

func _ready() -> void:
	super._ready();
	tileOffsetY = 1.1;
	self.connect("mouse_entered", self.onMouseEntered);
	self.connect("mouse_exited", self.onMouseExited);
	meshScene = get_children()[0];
	meshInstance = meshScene.get_children()[0];
	arrowInstance = arrowResource.instantiate();
	add_child(arrowInstance);

	arrowInstance.position.x = sizeX -1;
	arrowInstance.position.z = sizeY -1;
	arrowInstance.position.y = sizeZ + 0.25;
	arrowInstance.visible = false;
	meshInstance.material_override = BoardItemResource.getMaterial(color, BoardItemResource.MaterialType.NORMAL);
	redraw();

func onMouseEntered():
	if _picked_up:
		return;
	_selected = true;
	setMaterial();

func onMouseExited():
	if _picked_up:
		return;
	_selected = false;
	setMaterial();

func onStartPickUp():
	_picked_up = true;
	gridRoot.visible = false;
	positionOnPickup = Vector3(global_position);
	setMaterial();

func onEndPickUp():
	_picked_up = false;
	gridRoot.visible = true;
	setMaterial();

func setMaterial():
	if _picked_up:
		arrowInstance.visible = true;
		meshInstance.material_override = BoardItemResource.getMaterial(color, BoardItemResource.MaterialType.FOCUS);
		return;
	else:
		arrowInstance.visible = false;
	if _selected && !fixed:
		meshInstance.material_override = BoardItemResource.getMaterial(color, BoardItemResource.MaterialType.HOVER);
	else:
		meshInstance.material_override = BoardItemResource.getMaterial(color, BoardItemResource.MaterialType.NORMAL);


func getSize():
	return Vector2(sizeX, sizeZ);

func rotateFacingDirection():
	if facingDirection == FacingDirection.WEST:
		facingDirection = FacingDirection.NORTH;
	else:
		facingDirection += 90;
