extends Control

export(String, FILE, "*.tscn") var main_menu; 
export var scroll_speed = 25;
export var max_distance = 500;

var in_transit = true;

onready var text = $Scroll;

func _process(delta):
	text.rect_position += Vector2.UP * scroll_speed * delta;
	if((text.rect_position.y < max_distance || Input.is_action_just_released("gp_cancel")) && in_transit):
		Transitions.fade_out(self, main_menu, 2.5, Color.black);
		in_transit = false;
