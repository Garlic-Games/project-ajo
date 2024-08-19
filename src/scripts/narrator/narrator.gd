class_name Narrator
extends Node

@export var label_subtitles: Label = null;
@export var lines: Array[String] = [];
@export var seconds_between_lines: float = 2.0;

var tween: Tween;

func play_narration():
	tween = get_tree().create_tween();
	tween.tween_property(label_subtitles, "text", "", 0.0);
	
	for line in lines:
		tween.tween_property(label_subtitles, "text", line, line.length() / 20.0);
		tween.tween_interval(seconds_between_lines);
		tween.tween_property(label_subtitles, "text", "", 0.0);
