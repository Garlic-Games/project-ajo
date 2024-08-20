extends Node

@onready var speech_one: Narrator = $NarratorContainer/SpeechOne
@onready var speech_two: Narrator = $NarratorContainer/SpeechTwo
var second_speech_played: bool = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if speech_one:
		speech_one.play_narration();


func _on_board_grid_item_board_accessed() -> void:
	if not second_speech_played:
		if speech_one.tween.is_running():
			speech_one.tween.finished.connect(speech_two.play_narration);
		else:
			speech_two.play_narration();
		second_speech_played = true;
