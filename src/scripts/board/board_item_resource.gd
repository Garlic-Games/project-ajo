extends Node

enum MaterialType{HOVER, NORMAL, FOCUS};

var hovers = [];
var normals = [];
var focus = [];

func _ready() -> void:
	hovers.append(preload("res://art/materials/bricks/01/hover.tres"));
	normals.append(preload("res://art/materials/bricks/01/normal.tres"));
	focus.append(preload("res://art/materials/bricks/01/focus.tres"));
	hovers.append(preload("res://art/materials/bricks/02/hover.tres"));
	normals.append(preload("res://art/materials/bricks/02/normal.tres"));
	focus.append(preload("res://art/materials/bricks/02/focus.tres"));
	hovers.append(preload("res://art/materials/bricks/03/hover.tres"));
	normals.append(preload("res://art/materials/bricks/03/normal.tres"));
	focus.append(preload("res://art/materials/bricks/03/focus.tres"));

func getMaterial(color: int, type: MaterialType):
	match type:
		MaterialType.HOVER:
			return hovers[color];
		MaterialType.NORMAL:
			return normals[color];
		MaterialType.FOCUS:
			return focus[color];
	
