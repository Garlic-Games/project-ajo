extends Node3D

@export var pathPoints: Array[Node3D] =[];
@onready var camera: Camera3D = $Camera3D;

func _ready() -> void:
	camera.global_transform = pathPoints[pathPoints.size()-1].global_transform;
	var tween = get_tree().create_tween();
	for point in pathPoints:
		tween.tween_property(camera, "global_position", point.global_position, 5);
		tween.tween_property(camera, "global_rotation", point.global_rotation, 0.5);
		point.visible = false;
	tween.set_loops(60);
