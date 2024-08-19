class_name PlayerHud extends CanvasLayer

@onready var eToInteractLabel = $Container/Table;
@onready var eToNextLabel = $Container/EndLevel;

func setTableLvisibility(visible: bool):
	eToInteractLabel.visible = visible;
	
func setEndLevelVisibility(visible: bool):
	eToNextLabel.visible = visible;
	
