extends Node

@onready var board: Board = $Board;

var boardstate = false;

func _ready() -> void:
	var brik2x2 = preload("res://prefabs/board/items/Item2x2.tscn");
	var brik1x1 = preload("res://prefabs/board/items/Item1x1.tscn");
	var flat1x1 = preload("res://prefabs/board/items/Item1x05.tscn");
	var item = brik2x2.instantiate();
	item.color = 0;
	board.registerItem(item, 2, 2);
	var item2 = brik2x2.instantiate();
	item2.color = 1;
	board.registerItem(item2, 5, 2);
	var item3 = brik1x1.instantiate();
	item3.item_id = "ASD;";
	item3.color = 2;
	board.registerItem(item3, 3, 4);
	var item4 = flat1x1.instantiate();
	item4.color = 1;
	item4.fixed = true;
	board.registerItem(item4, 4, 4);

	board.setSize(Vector2(7,9));


func _process(delta: float) -> void:
	if Input.is_action_just_released("pause"):
		boardstate = !boardstate;
		board.changeState(boardstate);
