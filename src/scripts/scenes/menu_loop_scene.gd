extends Node3D

@export var pathPointsParent: Node3D;
@onready var camera: Camera3D = $Camera3D;

var _pathPoints: Array[Node3D] = [];
func _ready() -> void:
	_pathPoints.append_array(pathPointsParent.get_children());
	camera.global_transform = _pathPoints[_pathPoints.size()-1].global_transform;
	
	camera_paseo();

func camera_paseo():
	var tween = get_tree().create_tween();
	for point in _pathPoints:
		tween.tween_property(camera, "global_transform", point.global_transform, 3);
		point.visible = false;
	tween.tween_callback(camera_paseo);
