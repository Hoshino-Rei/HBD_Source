extends Sprite

func _ready():
	$Tween.interpolate_property(self, "modulate:a", 0.5, 0.0, 0.5, Tween.TRANS_QUART, Tween.EASE_IN_OUT, 0);
	$Tween.start();

func _delete_me():
	queue_free();
