extends Node2D
onready var start_position = global_position
onready var target_position = global_position
export(int) var wander_range = 32
onready var timer = $Timer

func update_target_position():
	var target_vector = Vector2(rand_range(-wander_range, wander_range), rand_range(-wander_range, wander_range))
	target_position = start_position + target_vector
	
func _on_Timer_timeout():
	update_target_position()
	
func get_time_left():
	return timer.time_left
	
func set_wander_time(wander_time):
	timer.wait_time = wander_time
	timer.start()
