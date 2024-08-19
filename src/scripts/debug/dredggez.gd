extends Node3D

@export var narrator: Narrator = null;
@export var narrator2: Narrator = null;

func _ready() -> void:
	var t = get_tree().create_tween();
	t.tween_interval(5.0);
	t.tween_callback(func(): narrator.play_narration())
