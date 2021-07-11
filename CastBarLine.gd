extends Line2D
signal trigger_cast

func _decrease():
	points[1].x -= 1
	
func fire():
	return points[1].x == 0

func _on_Timer_timeout():
	_decrease()
	if fire():
		emit_signal("trigger_cast")
