@tool
class_name BoardGridItem;
extends GridItem;
@onready var board_activator: BoardActivator = $BoardActivator
signal board_accessed;

func _ready() -> void:
	if board_activator:
		position_change.connect(board_activator.move_player)
	board_activator.board_accessed.connect(_emit_board_access);

func setup(grid_manager: GiantGridManager):
	super.setup(grid_manager);
	board_activator.current_grid_manager = grid_manager;

func _emit_board_access():
	board_accessed.emit();
