extends Node2D
signal cast_finished


func _on_CastBarLine_trigger_cast():
	print("cast finished")
	emit_signal("cast_finished")
	queue_free()
