extends Node

@onready var board: Board = $Board;

var boardstate = false;

func _ready() -> void:
	var brik2x2 = preload("res://prefabs/board/items/Item2x2.tscn");
	var brik1x1 = preload("res://prefabs/board/items/Item1x1.tscn");
	var item = brik2x2.instantiate();
	board.registerItem(item, 2, 2);
	var item2 = brik2x2.instantiate();
	board.registerItem(item2, 5, 2);
	var item3 = brik1x1.instantiate();
	item3.item_id = "ASD;";
	board.registerItem(item3, 3, 4);
	board.setSize(Vector2(7,9));


func _process(delta: float) -> void:
	if Input.is_action_just_released("pause"):
		boardstate = !boardstate;
		board.changeState(boardstate);
