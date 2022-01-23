extends Node2D

export(String, FILE, "*.tscn") var tpto;
export(Vector2) var coords;
export(Vector2) var look_direction;

export(String, "TimelineDropdown") var timeline: String
var in_dialog = false;

func dg():
	if in_dialog:
		return
	var d = Dialogic.start(timeline, '', "res://addons/dialogic/Nodes/DialogNode.tscn",  false, true)
	get_parent().call_deferred('add_child', d);
	d.connect("timeline_end", self, 'dialog_ended');
	Utils.pause_game();
	in_dialog = true;

func gonext():
	yield(get_tree().create_timer(0.5), "timeout");
	Transitions.fade_out(get_tree().current_scene, tpto, 0.5, Color.black, coords, look_direction);
