extends Area2D


export(String, "TimelineDropdown") var timeline: String
var in_dialog = false;


func _on_StaticBody2D_body_entered(body):
	if(body is PlayerController && !EventManager.got_lighter):
		if(!EventManager.got_lighter):
			EventManager.got_lighter = true;
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
	queue_free()

