extends Area2D

export(String, FILE, "*.tscn") var tpto;
export(Vector2) var coords;
export(Vector2) var look_direction;

func _on_TP_body_entered(body):
	if body is PlayerController:
		Utils.pause_game()
		yield(get_tree().create_timer(0.5), "timeout");
		Transitions.fade_out(get_tree().current_scene, tpto, 1.5, Color.black, coords, look_direction);


