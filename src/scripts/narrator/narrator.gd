class_name Narrator
extends Node

@export var background: Control = null;
@export var label_subtitles: RichTextLabel = null;
@export var lines: Array[String] = [];
@export var seconds_between_lines: float = 1;

var tween: Tween;

func play_narration():
	tween = get_tree().create_tween();
	tween.tween_property(background, "visible", true, 0.0);
	tween.tween_property(label_subtitles, "text", "", 0.0);

	for line in lines:
		tween.tween_property(label_subtitles, "text", line, line.length() / 40.0);
		tween.tween_interval(seconds_between_lines);
		tween.tween_property(label_subtitles, "text", "", 0.0);

	tween.tween_property(background, "visible", false, 0.0);
