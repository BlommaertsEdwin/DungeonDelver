extends Node

export var max_health = 10
onready var current_health = max_health setget take_damage, get_current_health
signal no_health
signal health_changed(health)

func take_damage(damage):
	current_health -= damage
	emit_signal("health_changed", current_health)
	if current_health <= 0:
		emit_signal("no_health")
		
func get_current_health():
	return current_health
	
func health():
	return current_health
