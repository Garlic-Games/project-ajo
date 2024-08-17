class_name BoardItem extends BoardGridBase

signal self_picked_up;

@export var sizeZ = 1;

var meshInstance: MeshInstance3D;


var hover_material: StandardMaterial3D = preload("res://art/materials/hover_tile_material.tres");
#var normal_material: StandardMaterial3D = preload("res://art/materials/standard_tile_material.tres");
var picked_up_material: StandardMaterial3D = preload("res://art/materials/picked_up_tile_material.tres");
var item_id: String = "";

var _selected = false;
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
	redraw();

func onMouseEntered():
	_selected = true;
	meshInstance.material_override = hover_material;

func onMouseExited():
	_selected = false;
	meshInstance.material_override = null;

func onStartPickUp():
	positionOnPickup = Vector3(global_position);
	meshInstance.material_override = picked_up_material;

func onEndPickUp():
	meshInstance.material_override = null;


func connectPickupJustOnce(call: Callable):
	if _lastConnection != null:
		disconnect("self_picked_up", _lastConnection);
	_lastConnection = call;
	connect("self_picked_up", _lastConnection);
	
func getSize():
	return Vector2(sizeX, sizeZ);
