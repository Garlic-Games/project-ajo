class_name PlayerHud extends CanvasLayer

@onready var eToInteractLabel = $Container/Table
@onready var eToNextLabel = $Container/EndLevel;
@onready var eToTwistLabel = $Container/EndLevel2;
@onready var boardCaption = $PanelContainer;

var inTableArea: bool = false:
	set(val):
		inTableArea = val;
		_checkVisibility();

var inEndArea: bool = false:
	set(val):
		inEndArea = val;
		_checkVisibility();


var inTwistArea: bool = false:
	set(val):
		inTwistArea = val;
		_checkVisibility();

var editingBoard: bool = false:
	set(val):
		editingBoard = val;
		_checkVisibility();

func _ready() -> void:
	_checkVisibility();

func _checkVisibility():
	boardCaption.visible = editingBoard;
	eToInteractLabel.visible = !editingBoard && inTableArea;
	eToNextLabel.visible = inEndArea;
	eToTwistLabel.visible = inTwistArea;
