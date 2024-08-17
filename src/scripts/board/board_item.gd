class_name BoardItem extends BoardGridBase

signal self_picked_up;

@onready var arrowResource = preload("res://art/models/kenney_brick-kit/mix/Arrow.tscn");
@export var sizeZ = 1;
@export var color = 0;
@export var fixed = false;

var meshInstance: MeshInstance3D;
var arrowInstance;

var item_id: String = "";

var _selected = false;
var _picked_up = false;
var _lastConnection = null;

var positionOnPickup: Vector3;

func _process(delta: float) -> void:
	super._process(delta);
	if(Input.is_action_just_released("primary_click")):
		if _selected:
			self_picked_up.emit();

func redraw() -> void:
	spawn_grid();

func _ready() -> void:
	super._ready();
	tileOffsetY = 1.1;
	self.connect("mouse_entered", self.onMouseEntered);
	self.connect("mouse_exited", self.onMouseExited);
	meshInstance = get_children()[0].get_children()[0];
	arrowInstance = arrowResource.instantiate();
	add_child(arrowInstance);
	arrowInstance.position.x = sizeX/2;
	arrowInstance.position.z = sizeY/2;
	arrowInstance.position.y = sizeZ + 0.25;
	arrowInstance.visible = false;
	meshInstance.material_override = BoardItemResource.getMaterial(color, BoardItemResource.MaterialType.NORMAL);
	redraw();

func onMouseEntered():
	_selected = true;
	setMaterial();

func onMouseExited():
	_selected = false;
	setMaterial();

func onStartPickUp():
	_picked_up = true;
	positionOnPickup = Vector3(global_position);
	setMaterial();

func onEndPickUp():
	_picked_up = false;
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
	
		

func connectPickupJustOnce(call: Callable):
	if _lastConnection != null:
		disconnect("self_picked_up", _lastConnection);
	_lastConnection = call;
	connect("self_picked_up", _lastConnection);

func getSize():
	return Vector2(sizeX, sizeZ);
