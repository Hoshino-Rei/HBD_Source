extends Area2D

export(String, "TimelineDropdown") var timeline: String
var in_dialog = false;



func _on_Event2_body_entered(body):
	if(body is PlayerController && EventManager.mouse_hole):
		if(EventManager.mouse_hole):
			EventManager.mouse_hole = false;
		if in_dialog:
			return
		var dial = Dialogic.start(timeline, '', "res://addons/dialogic/Nodes/DialogNode.tscn",  false, true)
		get_parent().call_deferred('add_child', dial);
		dial.connect("timeline_end", self, 'dialog_ended');
		dial.connect("dialogic_signal", self, "changeScene", [])
		Utils.pause_game();
		in_dialog = true;

func dialog_ended(_node):
	Utils.resume_game();
	yield(get_tree().create_timer(0.5), "timeout");
	in_dialog = false;
