extends Control

export(String, FILE, "*.tscn") var target;

func _enter_tree():
	yield(get_tree().create_timer(2.5), "timeout");
	Transitions.call_deferred("fade_out", self, target, 0.5, Color.black);
