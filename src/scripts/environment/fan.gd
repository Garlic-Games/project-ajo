extends Node3D

@onready var blades: Node3D = $Body/Mesh/Blades;
@onready var wind_area: Area3D = $WindArea;
@onready var debug_node: Node3D = $Debug;

@export var debug_mode: bool = false;
@export var angular_speed: float = -720.0;
@export var wind_velocity: float = 20.0;

func _ready() -> void:
	if not debug_mode:
		debug_node.queue_free();

	wind_area.body_entered.connect(func(entity: Node3D): on_entity_enters_wind_area(entity));
	wind_area.body_exited.connect(func(entity: Node3D): on_entity_leaves_wind_area(entity));

func _process(delta: float) -> void:
	blades.rotate_z(deg_to_rad(angular_speed * delta));

func on_entity_enters_wind_area(entity: Node3D) -> void:
	if entity is Player:
		entity.set_wind_velocity(wind_velocity * get_global_direction());

func on_entity_leaves_wind_area(entity: Node3D) -> void:
	if entity is Player:
		entity.set_wind_velocity(Vector3.ZERO);

func get_global_direction() -> Vector3:
	return global_transform.basis.z.normalized();
