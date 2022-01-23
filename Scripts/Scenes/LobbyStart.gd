extends Node2D

export(String, "TimelineDropdown") var timeline: String
onready var anim = $"../AnimationPlayer";
var in_dialog = false;

func _ready():
	if(EventManager.firstlobby):
		anim.play("LobbyCutscene");
		EventManager.firstlobby = false;

func start_dialog():
	if in_dialog:
		return
	var d = Dialogic.start(timeline, '', "res://addons/dialogic/Nodes/DialogNode.tscn",  false, true)
	get_parent().call_deferred('add_child', d);
	d.connect("timeline_end", self, 'dialog_ended');
	d.connect("dialogic_signal", self, "changeScene", [])
	Utils.pause_game();
	in_dialog = true;



func dialog_ended(_node):
	Utils.resume_game();
	yield(get_tree().create_timer(0.5), "timeout");
	in_dialog = false;
