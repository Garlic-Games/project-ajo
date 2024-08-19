@tool
class_name  GiantGridManager;
extends Node3D

signal victory;
signal item_moved;

@export var offset: Vector3:
	set(val):
		offset = val;
		_readjust_positions();
@export var boards: Array[BoardGridItem];
@export var grid_size: Vector2i;
@export var cell_size: float;
@export var blocked_positions: Array[Vector2i]

var pieces: Dictionary = {};
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		return;
	_register_children();
	if not boards.is_empty():
		for board in boards:
			board.board_activator.board.setBlockedPositions(blocked_positions);
			board.board_activator.board.setSize(grid_size);
			board.board_activator.board.item_moved.connect(func (item: BoardItem, coords: Vector3i, rotationDeg: Vector3): _children_moved(board.board_activator.board, item, coords, rotationDeg));
	_readjust_positions();

func _children_moved(board:Board, item: BoardItem, coords: Vector3i, rotationDeg: Vector3):
	var piece = pieces.get(item.item_id) as GridItem;
	if not piece:
		return;
	piece.grid_position = Vector3i(coords.y, coords.z, coords.x);
	piece.rotation_degrees = rotationDeg;
	var excluded_boards = boards.filter( func(r): return r.board_activator.board != board )\
				.map(func(r): return r.board_activator.board );
	print(excluded_boards.get_typed_class_name());
	_sync_boards(excluded_boards, item, coords, rotationDeg);

func _sync_boards(board_list: Array, item: BoardItem, coords: Vector3i, rotationDeg: Vector3):
	for curr_board in board_list:
		_move_item(curr_board, item, coords, rotationDeg);

func _move_item(curr_board:Board, item: BoardItem, coords: Vector3i, rotationDeg: Vector3):
	var new_item = curr_board.items_dictionary.get(item.item_id) as BoardItem;
	if item.itemParent is BoardTable:
		curr_board.boardTable.setItem(new_item, coords.x, coords.y);
	else:
		var parent_item = curr_board.items_dictionary.get(item.itemParent.item_id) as BoardItem;
		parent_item.setItem(new_item, item.coordX, item.coordY)
		_move_item(curr_board, parent_item, coords, rotationDeg);

func _register_children():
	boards.clear();
	for item in get_children():
		if item is BoardGridItem:
			boards.append(item);
		if item is VictoryGridItem:
			item.connect("victory", _victory_reached)

	for item in get_children():
		var gi = item as GridItem;
		if not gi:
			continue;
		gi.setup(self);
		gi.position_change.connect(_item_has_moved);
		pieces.get_or_add(item.name, item);
		if not boards.is_empty():
			for board in boards:
				if board.board_activator.board:
					var small_piece = gi.loaded_item;
					if not gi.is_controlled_by(board):
						small_piece.fixed = true;
					if small_piece.canConstructOver:
						small_piece.color = 1;
					if small_piece.fixed:
						small_piece.color = 2;
					board.board_activator.board.registerItem(small_piece, gi.grid_position.z, gi.grid_position.x);

func _readjust_positions():
	for item in get_children():
		var gi = item as GridItem;
		if not gi:
			continue;
		gi.grid_offset = offset;

func _victory_reached():
	victory.emit();

func _item_has_moved(_new_position: Vector3):
	item_moved.emit();
