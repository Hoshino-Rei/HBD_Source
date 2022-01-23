extends Node2D

export var max_health = 2750.2;
export var arm_rotation_speed = 1.0;

onready var arm_parent = $Skeleton2D/Root/Torso/Arm_parent
onready var hbar = $"../../UI/BossHealth/Control/ProgressBarFG";
onready var hbgbar = $"../../UI/BossHealth/Control/ProgressBarBG";
onready var mhbar = $"../../UI/BossHealth/Control2/ProgressBarFG";
onready var mhbgbar = $"../../UI/BossHealth/Control2/ProgressBarBG";

onready var cam = $"../../Camera2D";
var arm = preload("res://Prefabs/Arm.tscn");
var arms = [];

enum state_mechine {INTRO = 0, VERSE = 1, PRE_CHORUS = 2, CHORUS = 3, BRIDGE = 4, OUTRO = 5};
var state = state_mechine.INTRO;

var current_health = 0.0;
var dead = false;
var count = 4
var radius = 1.0
var radius_max = 32.0
var radius_magntude = 0.5

# Get how much of an angle objects will be spaced around the circle.
# Angles are in radians so 2.0*PI = 360 degrees
var angle_step = 2.0*PI / count

var angle = 0
var s_val = 0;

func _ready():
	current_health = max_health;

func create_arms():
	for _i in range(0, count):
		var direction = Vector2(cos(angle), sin(angle))
		var pos = arm_parent.position + direction * 480
		var ar = arm.instance()
		arm_parent.add_child(ar)
		ar.position = pos
		angle += angle_step
		arms.append(ar);

func _process(delta):
	match state:
		state_mechine.INTRO:
			intro_state(delta);
		state_mechine.VERSE:
			pass
		state_mechine.PRE_CHORUS:
			pass
		state_mechine.CHORUS:
			pass
		state_mechine.BRIDGE:
			pass
		state_mechine.OUTRO:
			pass
	var mapped_health = Utils.map_range(current_health, 0, max_health, 0, 1);
	hbar.value = move_toward(hbar.value, mapped_health, 1.5 * delta);
	hbgbar.value = move_toward(hbgbar.value, mapped_health, 1 * delta);
	mhbar.value = move_toward(hbar.value, mapped_health, 1.5 * delta);
	mhbgbar.value = move_toward(hbgbar.value, mapped_health, 1 * delta);

func intro_state(delta) -> void:
	if(arms.size() > 0):
		s_val += delta;
		radius = sin(s_val * radius_magntude) * radius_max;
		angle += arm_rotation_speed * delta
		for i in arms:
			i.came = cam;
			var direction = Vector2(cos(angle), sin(angle))
			var pos = arm_parent.position + direction * radius
			i.position = i.position.move_toward(pos, 150 * delta);
			i.rotation_degrees = rad2deg(i.position.angle_to_point(arm_parent.position)) - 180
			angle += angle_step

func verse_state(delta) -> void:
	if(arms.size() > 0):
		s_val += delta;
		radius = sin(s_val * radius_magntude) * radius_max;
		angle += arm_rotation_speed * delta
		for i in arms:
			var direction = Vector2(cos(angle), sin(angle))
			var pos = arm_parent.position + direction * radius
			i.position = i.position.move_toward(pos, 150 * delta);
			i.rotation_degrees = rad2deg(i.position.angle_to_point(arm_parent.position)) - 180
			angle += angle_step
func music_ended():
	print("so desu ne");
	
func battle_start():
	for i in arms:
		cam.shake(2,8,3);
		i.shoot = true;

func _on_Collider_area_entered(area):
	current_health -= area.dmg;
	area.queue_free()
	if(current_health < 0):
		dead = true;
		print("daed")
