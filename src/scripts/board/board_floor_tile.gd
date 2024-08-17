class_name BoardFloorTile extends StaticBody3D

@onready var meshInstance: MeshInstance3D = $MeshInstance3D;

var coordX = 0;
var coordY = 0;

var hover_material: StandardMaterial3D = preload("res://art/materials/hover_tile_material.tres");
var normal_material: StandardMaterial3D = preload("res://art/materials/hover_tile_material.tres");



func _ready() -> void:
	self.connect("mouse_entered", self.onMouseEntered);
	self.connect("mouse_exited", self.onMouseExited);

func onMouseEntered():
	meshInstance.material_override = hover_material;
	
func onMouseExited():
	print("Mouse exited");
	meshInstance.material_override = null;
