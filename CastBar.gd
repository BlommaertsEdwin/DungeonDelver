extends Node2D
signal cast_finished


func _on_CastBarLine_trigger_cast():
	emit_signal("cast_finished")
	queue_free()
