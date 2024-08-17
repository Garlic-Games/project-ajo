class_name BoardItem extends Node

# x11 = 1x1 // x12 = 1x2, x22 = 2x2
enum ItemShape {x11, x12, x22, x24, x44}

@export var itemShape: ItemShape = ItemShape.x12;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
