extends Node2D

export var fireRate = 1.0;
export var shoot = false;

var fire_dur = 0.0;
var bulletpath = preload("res://Prefabs/BBullet.tscn");
var dmg = 20;
var came = null

onready var bulletbarrel = $Skeleton2D/Shoulder_L/UpperArm_L/LowerArm_L/Hand_L/Node2D;

func _process(delta):
	if shoot:
		if(fire_dur <= 0):
			fire_dur = fireRate;
		if (fire_dur == fireRate):
			var b = bulletpath.instance();
			b.position = bulletbarrel.global_position;
			b.rotation_degrees = rotation_degrees-90;
			came.shake(2,8,3);
			dmg = b.dmg;
			get_tree().root.add_child(b);
		fire_dur -= delta;

func _on_Collider_body_entered(body):
	if body is PlayerMoon:
		body.get_hit(dmg);
