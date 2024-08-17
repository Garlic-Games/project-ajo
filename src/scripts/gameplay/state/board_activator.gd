class_name BoardActivator;
extends StaticBody3D

@export var board: Board;

func activate_board():
	board.changeState(true);
