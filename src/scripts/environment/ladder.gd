extends Node

@onready var ladder_area: Area3D = $LadderArea;

func _ready() -> void:
	ladder_area.body_entered.connect(func(entity: Node3D): on_entity_enters_area(entity));
	ladder_area.body_exited.connect(func(entity: Node3D): on_entity_leaves_area(entity));

func on_entity_enters_area(entity: Node3D) -> void:
	if entity is Player:
		entity.set_climbing_mode(true);

func on_entity_leaves_area(entity: Node3D) -> void:
	if entity is Player:
		entity.set_climbing_mode(false);
