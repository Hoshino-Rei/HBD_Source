extends Area2D

export var max_health = 100;
export var damage = 100;

export var speed = 3;
export var speed_cap = 0.5;
var cur_speed = 0;

var target = null;
var take_damage = false;
var dead = false;
var once = false;
onready var health = max_health;
onready var sfx = $AudioStreamPlayer2D;
onready var sfx2 = $Dying;
onready var dmg = $Damage;

func _process(delta):
	if !dead:
		if target != null:
			position = position.move_toward(target.position, cur_speed * delta)
		
		if health < 0:
			dead = true
		if take_damage:
			if !sfx2.playing:
				sfx2.play();
			health -= damage * delta;
			cur_speed = speed * speed_cap;
			dmg.modulate.a = lerp(dmg.modulate.a, 1.0, 0.125);
		else:
			dmg.modulate.a = lerp(dmg.modulate.a, 0.0, 0.125);
			cur_speed = speed;
			sfx2.stop();
	else:
		if !once:
			collision_layer = 1;
			collision_mask = 1;
			var tween = Tween.new()
			add_child(tween);
			tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 2, Tween.TRANS_QUART, Tween.EASE_IN_OUT, 0);
			tween.start()
			once = true
			sfx.play();
			yield(tween, "tween_all_completed")


func _on_Enemy_area_entered(area):
	if( area.name == "Damage_Area"):
		take_damage = true;
	elif(area.name == "DamageArea"):
		dead = true

func _on_Enemy_area_exited(_area):
	take_damage = false;

func _on_AudioStreamPlayer2D_finished():
	queue_free();


