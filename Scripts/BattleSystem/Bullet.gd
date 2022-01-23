extends Area2D

export var speed = 1000;
export var dmg = 10;

var velo : Vector2;
var viewRect : Rect2;
var local_life = 0;

func _ready():
	viewRect = get_viewport_rect();

func _process(delta):
	position -= transform.y * speed * delta;
	wrapObject(position, viewRect, 10);
	local_life -= delta;
	if local_life < 0:
		#spawn particals!
		pass

func wrapObject(posi:Vector2, scresize:Rect2, wrpMar:float): 
	if posi.x > scresize.end.x + wrpMar || posi.x < scresize.position.x - wrpMar || posi.y > scresize.end.y + wrpMar || posi.y < scresize.position.y - wrpMar:
		self.queue_free();


