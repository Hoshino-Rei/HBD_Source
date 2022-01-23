extends KinematicBody2D
class_name PlayerController

const SPEED_MUL = 100;

export var walkSpeed = 5.0;
export var runSpeed = 10.0;
export var maxSpeed = 10.0;
export var smoothSpeed = 0.1;
export var acc = 400.0;
export var frac = 400.0;

onready var i_ray = $IntractionRay;
onready var flash  = $IntractionRay/SpotLight;
onready var animPlayer = $AnimationPlayer;
onready var animTree = $AnimationTree;
onready var sfx = $AudioStreamPlayer2D;
onready var animTreeState = animTree.get("parameters/playback");
export var in_basement = false;

var footstep_01 = preload("res://Sounds/SFXs/high_heel_001.wav");
var footstep_02 = preload("res://Sounds/SFXs/high_heel_002.wav");
var footstep_03 = preload("res://Sounds/SFXs/high_heel_003.wav");
var steps = [footstep_01, footstep_02, footstep_03];


export var inputDir : Vector2;
export var starting_angle : Vector2;
var velo : Vector2;
var moveDir : Vector2;
export var speed = 0.0;

var run = false;

var can_move = true;
var can_run = true;
export var in_cutscene = false;

func _ready():
	flash.visible = false;
	var _c = Utils.connect("on_pause_request", self, "canMove", [], CONNECT_DEFERRED)

func _process(delta):
	if(!in_cutscene):
		inputDir.x = Input.get_action_strength("gp_right") - Input.get_action_strength("gp_left");
		inputDir.y = Input.get_action_strength("gp_down") - Input.get_action_strength("gp_up");
		inputDir = inputDir.normalized();
		run = Input.is_action_pressed("gp_run");
	
	if in_basement:
		flash.visible = true;
	else: 
		flash.visible = false;
	
	if can_move:
		if run && can_run:
			speed = lerp(speed, runSpeed, smoothSpeed * delta);
		else:
			speed = lerp(speed, walkSpeed, smoothSpeed * delta);
		
		if(inputDir != Vector2.ZERO):
			i_ray.rotation = -atan2(inputDir.x, inputDir.y);

func _physics_process(delta):
	if can_move:
		animTree.set("parameters/Idle/blend_position", inputDir + starting_angle);
		animTree.set("parameters/Walk/blend_position", inputDir + starting_angle);
		animTree.set("parameters/Run/blend_position", inputDir + starting_angle);
		if inputDir != Vector2.ZERO:
			animTree.set("parameters/Idle/blend_position", inputDir);
			animTree.set("parameters/Walk/blend_position", inputDir);
			animTree.set("parameters/Run/blend_position", inputDir);
			starting_angle = inputDir
			if !(run && can_run):
				animTreeState.travel("Walk");
			else:
				animTreeState.travel("Run");
			
			velo +=  inputDir * acc * delta;
			velo = velo.clamped(maxSpeed);
		else:
			animTreeState.travel("Idle");
			velo = velo.move_toward(Vector2.ZERO, frac * delta);
		
		moveDir = velo * speed;
		moveDir = move_and_slide(moveDir * SPEED_MUL * delta);

func canMove(state):
	reset_state();
	can_move = !state;

func reset_state():
	velo = Vector2.ZERO;
	inputDir = Vector2.ZERO;
	animTreeState.travel("Idle");


func _steppies() -> void:
	sfx.stream = steps[rand_range(0 ,steps.size())]
	sfx.play();
	#print("step on m-");

