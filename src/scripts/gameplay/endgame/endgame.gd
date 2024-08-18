extends Node

@onready var player: Player = $Player;
@onready var the_b0ss: CoolGarlic = $TheB0ss;
@onready var the_b0ss_area: Area3D = $TheB0ss/Area3D;
@onready var look_at_me: Node3D = $CameraWaypoints/CameraPoint1;
@onready var last_sight: Node3D = $CameraWaypoints/CameraPoint2;
@onready var falling_blocks: Node3D = $Player/FallingBlocks;
@onready var light: SpotLight3D = $Light/AnimSpotLight;
@onready var label_subtitles : Label = $TwoD/Subtitles;
@onready var fade_rectangle : ColorRect = $TwoD/Black;

var animation_started : bool = false;

func _ready() -> void:
	the_b0ss_area.body_entered.connect(func(entity: Node3D): the_b0ss_is_talking_now());
	
	label_subtitles.text = "";
	
	var tween_fade: Tween = get_tree().create_tween();
	tween_fade.tween_property(fade_rectangle, "color:a", 0.0, 2);

func the_b0ss_is_talking_now():
	player.lock(true);
	
	var initial_camera_transform: Transform3D = player.camera.global_transform;
	player.camera.look_at(look_at_me.global_position);
	var b0ss_camera_transform: Transform3D = player.camera.global_transform;
	player.camera.look_at(last_sight.global_position);
	var up_camera_transform: Transform3D = player.camera.global_transform;
	
	player.camera.global_transform = initial_camera_transform;

	var tween_speech: Tween = get_tree().create_tween();
	tween_speech.tween_property(player.camera, "global_transform", b0ss_camera_transform, 1.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT);
	tween_speech.tween_interval(1.0);
	tween_speech.tween_property(label_subtitles, "text", "Congratulations, my fellow prisoner.", 1.7);
	tween_speech.tween_interval(2.0);
	tween_speech.tween_property(label_subtitles, "text", "", 0.0);
	tween_speech.tween_property(label_subtitles, "text", "It seems you have proven yourself worthy of my experiment.", 2.9);
	tween_speech.tween_interval(2.0);
	tween_speech.tween_property(label_subtitles, "text", "", 0.0);
	tween_speech.tween_property(label_subtitles, "text", "Unfortunately, you have become useless to me.", 2.4);
	tween_speech.tween_interval(2.0);
	tween_speech.tween_property(label_subtitles, "text", "", 0.0);
	tween_speech.tween_property(label_subtitles, "text", "Get bricked.", 0.6);
	tween_speech.tween_interval(3.0);
	tween_speech.tween_property(label_subtitles, "text", "", 0.0);
	tween_speech.tween_callback(block_mayhem);
	tween_speech.tween_property(player.camera, "global_transform", up_camera_transform, 3.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT);
	tween_speech.tween_property(light, "spot_angle", 180, 3.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT);

	tween_speech.is_queued_for_deletion();

func block_mayhem():
	var tween: Tween = get_tree().create_tween();
	tween.tween_property(falling_blocks, "position", Vector3(0.0, -1.4, 0.0), 8.0).set_trans(Tween.TRANS_QUART);
