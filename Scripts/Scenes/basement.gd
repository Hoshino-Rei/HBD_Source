extends Node2D

export var musicDistance = 800;
export var max_enemies = 3;

export(String, "TimelineDropdown") var timeline: String
var in_dialog = false;

onready var enemy = preload("res://Prefabs/Enemy.tscn");

onready var enemy_parent = $EParent;
onready var player = $YSort/Player;
onready var sp = $SP;
onready var mp = $Music;
onready var ap = $AnimationPlayer;

onready var enemySpawner01 = $SPE1;
onready var enemySpawner02 = $SPE2;
onready var enemySpawner03 = $SPE3;
onready var enemySpawner04 = $SPE4;
onready var enemySpawners = [enemySpawner01, enemySpawner02, enemySpawner03, enemySpawner04];

onready var closest_enemy = enemySpawner01;

onready var rootControl = CanvasLayer.new()
onready var colorRect = ColorRect.new()
onready var tween = Tween.new()

var player_dead = false;

func _ready():
	player.can_run = false;
	colorRect.set_frame_color(Color(0, 0, 0, 0))
	
	add_child(rootControl)
	rootControl.add_child(colorRect)
	rootControl.add_child(tween)

	colorRect._set_size(Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height")))
	
	if in_dialog:
		return
	var d = Dialogic.start(timeline, '', "res://addons/dialogic/Nodes/DialogNode.tscn",  false, true)
	get_parent().call_deferred('add_child', d);
	d.connect("timeline_end", self, 'dialog_ended');
	Utils.pause_game();
	in_dialog = true;


func dialog_ended(_node):
	Utils.resume_game();
	yield(get_tree().create_timer(0.5), "timeout");
	in_dialog = false;

func _process(_delta):
	if (enemy_parent.get_child_count() < max_enemies) && !EventManager.got_lighter:
		var e = enemy.instance();
		e.position = enemySpawners[rand_range(0, enemySpawners.size())].position;
		e.target = player;
		enemy_parent.add_child(e);
		closest_enemy = e;
	
	
	if EventManager.got_lighter:
		for e in enemy_parent.get_children():
			e.dead = true;
	
	if enemy_parent.get_child_count() > 0:
		for e in enemy_parent.get_children():
			if(!e.dead):
				if (e.global_position.distance_to(player.global_position) < closest_enemy.global_position.distance_to(player.global_position)):
						closest_enemy = e;
			else:
				closest_enemy = enemySpawner03;
	
	var ds = abs(closest_enemy.global_position.distance_to(player.global_position));
	mp.volume_db = Utils.map_range(ds, musicDistance, 20, -80, 2);
	
	if ds < 16 && player_dead == false:
		player_dead = true;

		tween.interpolate_property(colorRect, "color", Color(0, 0, 0, 0), Color.black, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()
		
		yield(tween, "tween_all_completed")

		closest_enemy = enemySpawner03;
		player.position = sp.position;
		for e in enemy_parent.get_children():
			e.position = Vector2(5000, 5000);
			e.dead = true
		
		tween.interpolate_property(colorRect, "color", Color.black, Color(0, 0, 0, 0), 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()
		
		yield(tween, "tween_all_completed")
		player_dead = false



func _on_Mouse_body_entered(body):
	if body is PlayerController:
		ap.play("Rat_Run");
		player.can_run = true;
