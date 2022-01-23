extends Control

export(String, FILE, "*.tscn") var target;

func _on_AudioStreamPlayer_finished():
	Transitions.fade_out(self, target, 1.5, Color.black);
