extends Control

export(String, FILE, "*.tscn") var start_scene; 
export(String, FILE, "*.tscn") var credits_scene; 
onready var start_btn = $VBoxContainer/Start;
onready var sfx = $AudioStreamPlayer2;
export(Resource) var select;
export(Resource) var click;
export(Resource) var exit;
onready var clicked = true;


func _ready():
	yield(get_tree().create_timer(0.5), "timeout");
	start_btn.grab_focus();


func _on_Start_pressed():
	if clicked:
		sfx.stream = click;
		sfx.play();
		clicked = false;
		yield(get_tree().create_timer(0.5), "timeout");
		Transitions.fade_out(self, start_scene, 2.5, Color.black);


func _on_Credits_pressed():
	if clicked:
		sfx.stream = click;
		sfx.play();
		clicked = false;
		yield(get_tree().create_timer(0.5), "timeout");
		Transitions.fade_out(self, credits_scene, 2.5, Color.black);


func _on_Quit_pressed():
	sfx.stream = exit;
	sfx.play();
	yield(get_tree().create_timer(0.5), "timeout");
	get_tree().quit()


func _on_focus_entered():
	sfx.stream = select;
	sfx.play();
