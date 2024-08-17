class_name Board extends Node3D

@onready var boardTable: BoardTable = $BoardTable;

var brik2x2 = preload("res://prefabs/board/items/Item2x2.tscn");
#Default true for debug
var edit_mode:bool = true; 

func changeState(newState: bool): 
	
	pass;

func registerItem(item: BoardItem):
	pass;

func _ready() -> void:
	boardTable.connect("item_picked_up", tableItemPickedUp);
	var item = brik2x2.instantiate();
	boardTable.setItem(item, 2, 2);
	var item2 = brik2x2.instantiate();
	boardTable.setItem(item2, 7, 2);

func tableItemPickedUp(item: BoardItem):
	boardTable.setItem(item, 5, 5);
	print(item);
