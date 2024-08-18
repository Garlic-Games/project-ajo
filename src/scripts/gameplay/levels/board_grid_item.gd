@tool
class_name BoardGridItem;
extends GridItem;
@onready var board_activator: BoardActivator = $BoardActivator

func _ready() -> void:
	position_change.connect(board_activator.move_player)
