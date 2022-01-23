extends Node

signal on_pause_request(state)

func map_range(value, leftMin, leftMax, rightMin, rightMax):
	# Figure out how 'wide' each range is
	var leftSpan = leftMax - leftMin
	var rightSpan = rightMax - rightMin
	# Convert the left range into a 0-1 range (float)
	var valueScaled = float(value - leftMin) / float(leftSpan)
	# Convert the 0-1 range into a value in the right range.
	return rightMin + (valueScaled * rightSpan)


func _wrap_object(posi:Vector2, scresize:Rect2, wrpMar:float): 
	if posi.x > scresize.end.x + wrpMar:
		posi.x = scresize.position.x - wrpMar;
	elif posi.x < scresize.position.x - wrpMar:
		posi.x = scresize.end.x + wrpMar;
		
	if posi.y > scresize.end.y + wrpMar:
		posi.y = scresize.position.y - wrpMar;
	elif posi.y < scresize.position.y - wrpMar:
		posi.y = scresize.end.y + wrpMar;
	return posi;

func pause_game():
	emit_signal("on_pause_request", true);

func resume_game():
	emit_signal("on_pause_request", false);
