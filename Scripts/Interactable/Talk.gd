extends StaticBody2D

export(String, "TimelineDropdown") var timeline: String
export(String) var tooltip = "Interact"

var in_dialog = false;
	
func interaction_can_interact(interactionComponentParent : Node) -> bool:
	return interactionComponentParent is PlayerController

# Not implemented - we'll use the default texture instead
#func interaction_get_texture() -> Texture:
#	pass

func interaction_get_text() -> String:
	return tooltip;

func interaction_interact(_interactionComponentParent : Node) -> void:
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
