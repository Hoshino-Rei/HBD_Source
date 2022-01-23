extends Node2D

export(Vector2) var coords;
export(Vector2) var look_direction;
export(String, FILE, "*.tscn") var tpto;
export(String, "TimelineDropdown") var timeline: String
var in_dialog = false;

func _ready():
	var dial = Dialogic.start(timeline, '', "res://addons/dialogic/Nodes/DialogNode.tscn",  false, true)
	get_parent().call_deferred('add_child', dial);
	dial.connect("timeline_end", self, 'dialog_ended');
	dial.connect("dialogic_signal", self, "changeScene", [])
	Utils.pause_game();

func dialog_ended(_node):
	Transitions.fade_out(get_tree().current_scene, tpto, 1.5, Color.black, coords, look_direction);
