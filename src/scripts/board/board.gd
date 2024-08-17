class_name Board extends Node3D

@onready var boardTable: BoardTable = $BoardTable;

#Default true for debug
var edit_mode:bool = true; 

func changeState(newState: bool): 
	
	pass;

func registerItem(item: BoardItem):
	pass;
