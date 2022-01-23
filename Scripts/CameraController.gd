extends "res://Scripts/Camera2DEX.gd"


onready var target = get_node("../Player");

func _process(_delta):
	position = target.global_position;
