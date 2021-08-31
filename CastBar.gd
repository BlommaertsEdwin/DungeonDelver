extends Node2D
signal cast_finished


func init(timer_tick:float):
	$CastBarLine/Timer.wait_time = timer_tick


func _on_CastBarLine_trigger_cast():
	emit_signal("cast_finished")
	queue_free()
