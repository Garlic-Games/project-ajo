class_name BoardFloorTile extends StaticBody3D

@onready var meshInstance: MeshInstance3D = $MeshInstance3D;
@onready var labelCoords: Label3D = $Label3D;

var itemParent: BoardGridBase;
var coordX = 0:
	set(val):
		coordX = val;
		_redrawLabel();
var coordY = 0:
	set(val):
		coordY = val;
		_redrawLabel();

var hover_material: StandardMaterial3D = preload("res://art/materials/hover_tile_material.tres");
var normal_material: StandardMaterial3D = preload("res://art/materials/hover_tile_material.tres");

var floorParent: BoardGridBase;

func _ready() -> void:
	self.connect("mouse_entered", self.onMouseEntered);
	self.connect("mouse_exited", self.onMouseExited);

func onMouseEntered():
	meshInstance.material_override = hover_material;

func onMouseExited():
	meshInstance.material_override = null;

func _redrawLabel():
	labelCoords.text = str(coordX) + "-" + str(coordY);
