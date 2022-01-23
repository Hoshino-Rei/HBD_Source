extends Node2D

export(String, FILE, "*.tscn") var tp; 
export(String, FILE, "*.tscn") var tp2; 




func _on_Area2D_body_entered(body):
	if body is PlayerController:
		yield(get_tree().create_timer(0.5), "timeout");
		Transitions.fade_out(self, tp, 2.5, Color.black);



func _on_Area2D2_body_entered(body):
	if body is PlayerController:
		yield(get_tree().create_timer(0.5), "timeout");
		Transitions.fade_out(self, tp2, 2.5, Color.black);
