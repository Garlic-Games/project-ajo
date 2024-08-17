class_name BoardItem extends StaticBody3D

# x11 = 1x1 // x12 = 1x2, x22 = 2x2
enum ItemShape {x11, x12, x22, x24, x44}

signal item_picked_up;

@export var itemShape: ItemShape = ItemShape.x12;
@onready var importedMesh: Node3D = $"round-lq-brick-2x2";
var meshInstance: MeshInstance3D;

var hover_material: StandardMaterial3D = preload("res://art/materials/hover_tile_material.tres");
#var normal_material: StandardMaterial3D = preload("res://art/materials/standard_tile_material.tres");
var picked_up_material: StandardMaterial3D = preload("res://art/materials/picked_up_tile_material.tres");

var _selected = false;
var _lastConnection = null;

var positionOnPickup: Vector3;

func _process(delta: float) -> void:
	if(Input.is_action_just_released("primary_click")):
		if _selected:
			item_picked_up.emit();
	

func _ready() -> void:
	self.connect("mouse_entered", self.onMouseEntered);
	self.connect("mouse_exited", self.onMouseExited);
	meshInstance = importedMesh.get_children()[0];

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
		disconnect("item_picked_up", _lastConnection);
	_lastConnection = call;
	connect("item_picked_up", _lastConnection);
	
func getSize():
	if itemShape == ItemShape.x22:
		return Vector2(2, 2);
