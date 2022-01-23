extends KinematicBody2D
class_name PlayerMoon

const SPEED_MUL = 100;

export var health = 100.0;
export var speed = 5.0;
export var dash_speed = 5.0;
export var dash_duration = 1.0;
export var fireRate = 0.2;
export var ghost_rate = 0.2;
export var ghost_timer = 0.2;
export var acc = 400.0;
export var frac = 400.0;
export var dashFrac = 400.0;
export var maxSpeed = 10.0;
export var smoothCAngle = 10;
export var smoothMAngle = 100;
export var warpMargin = 10;

onready var bulletbarrel = $Spawnpoint;
onready var i_framer = $I_frames;
onready var area = $Area2D;
onready var cam = $"../Camera2D";
onready var bsfx = $"BulletSFX";
onready var dsfx = $"DashSFX";
onready var hbar = $"../UI/Health/ProgressBarFG";
onready var hbgbar = $"../UI/Health/ProgressBarBG";

var bulletpath = preload("res://Prefabs/Bullet.tscn");
var ghost = preload("res://Prefabs/MoonGhost.tscn");

var screenSize : Rect2;

var input_vec : Vector2;
var look_vec : Vector2;
var dir_vec : Vector2;
var velo_vec : Vector2;
var dash_vec : Vector2;

var smoothAngle = 0.125;
var cur_health = 0.0;
var angle = 0.0;
var fire_dur = 0.0;
var ghost_dur = 0.0;
var ghost_timer_dur = 0.0;

var dashing = false;

var shoot = false;
var dash = false;
var dead = false;
var take_damage = true;
var clock = 0.0;

func _ready():
	screenSize = get_viewport_rect();
	cur_health = health;


func _input(event):
	if event is InputEventMouseMotion:
		smoothAngle = smoothMAngle;
		look_vec = -(position - event.position);
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	elif event is InputEventJoypadMotion:
		smoothAngle = smoothCAngle;
		look_vec = Input.get_vector("gp_lookleft", "gp_lookright", "gp_lookup", "gp_lookdown");
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);



func _process(delta):
	input_vec.x = Input.get_action_strength("gp_right") - Input.get_action_strength("gp_left");
	input_vec.y = Input.get_action_strength("gp_down") - Input.get_action_strength("gp_up");
	input_vec = input_vec.normalized();
	
	look_vec = look_vec.normalized();

	
	shoot = Input.is_action_pressed("gp_shoot");
	dash = Input.is_action_just_pressed("gp_dash");
	
	if(look_vec != Vector2.ZERO):
		angle = atan2(look_vec.y, look_vec.x);
	rotation = lerp_angle(rotation, angle, smoothAngle * delta);
	
	position = Utils._wrap_object(position, screenSize, warpMargin);
	
	if(fire_dur <= 0):
		fire_dur = fireRate;
	if (fire_dur == fireRate) && shoot:
		var b = bulletpath.instance();
		b.position = bulletbarrel.global_position;
		b.rotation_degrees = rotation_degrees+90;
		cam.shake(0.4,8,3);
		velo_vec -= transform.x * 8;
		bsfx.pitch_scale = rand_range(0.9,1.1);
		bsfx.play(0.0);
		get_parent().add_child(b);
	fire_dur -= delta;
	
	if(input_vec != Vector2.ZERO && dash):
		dash_vec += input_vec * dash_speed;
		ghost_timer_dur = ghost_timer;
		cam.shake(0.4,8,3);
		dashing = true;
		dsfx.pitch_scale = rand_range(0.9,1.1);
		dsfx.play(0.0);
	dash_vec = dash_vec.clamped(300);
	
	if dashing:
		if(ghost_dur <= 0):
			ghost_dur = ghost_rate;
		if (ghost_dur == ghost_rate):
			var g = ghost.instance();
			g.position = global_position;
			g.rotation_degrees = rotation_degrees;
			get_parent().add_child(g);
		ghost_dur -= delta;
	
	if(ghost_timer_dur > 0):
		ghost_timer_dur -= delta;
	else:
		dashing = false;
	dash_vec = dash_vec.move_toward(Vector2.ZERO, dashFrac * delta);
	
	var mapped_health = Utils.map_range(cur_health, 0, 100, 0, 1);
	hbar.value = move_toward(hbar.value, mapped_health, 1.5 * delta);
	hbgbar.value = move_toward(hbgbar.value, mapped_health, 1 * delta);
	
	clock += delta;
	if(take_damage):
		modulate.a = 1.0;
	else:
		modulate.a = sin(clock * 40);
	if(i_framer.is_stopped()):
		take_damage = !dashing;


func _physics_process(delta):
	if input_vec != Vector2.ZERO:
		velo_vec +=  input_vec * acc * delta;
		velo_vec = velo_vec.clamped(maxSpeed);
	else:
		velo_vec = velo_vec.move_toward(Vector2.ZERO, frac * delta);
	
	dir_vec = velo_vec * speed;
	
	dir_vec = move_and_slide(dir_vec + dash_vec * delta * SPEED_MUL);

func _on_Area2D_area_entered(_area):
	get_hit(_area.dmg, _area);

func freezframe(ts, td):
	Engine.time_scale = ts;
	yield(get_tree().create_timer(td * ts), "timeout");
	Engine.time_scale = 1.0;
	
func get_hit(dmg, obj = null):
	if take_damage:
		cur_health -= dmg;
		freezframe(0.2, 0.5)
		if obj != null:
			obj.queue_free()
		if(cur_health < 0):
			dead = true;
		i_framer.start()
		take_damage = false;


func _on_I_frames_timeout():
	take_damage = true;
