extends Label
onready var stats = $Stats

func _on_Stats_health_changed(health):
	text = str(health)
