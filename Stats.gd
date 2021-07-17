extends Node

export var max_health = 10.0
onready var current_health = max_health setget set_current_health, get_current_health
signal no_health
signal health_increased(health)
signal experience_changed
signal experience_required_changed
signal level_changed
export var experience_pool = 0 setget set_experience
export var experience_required = 200 setget set_experience_required
export var experience_points = 100
export var level = 1 setget set_level
export var regenerating = false
export var health_regen_tick = 2
const health_regen_per_level = {
	1: 6.8,
	2: 6.2,
	3: 5.6,
	4: 5,
	5: 4.4,
	6: 3.8,
	7: 3.2,
	8: 2.6,
	9: 2,
	10: 1.4,
}
var health_regen_timer

func _ready():
	health_regen_timer = Timer.new()
	health_regen_timer.wait_time = health_regen_tick
	health_regen_timer.connect("timeout", self, "regenerate_health")
	health_regen_timer.one_shot = false
	add_child(health_regen_timer)
	

func set_experience(experience):
	experience_pool += experience
	emit_signal("experience_changed")
	
func set_experience_required(experience_required):
	emit_signal("experience_required_changed")
	
func set_level(level):
	level += 1
	emit_signal("level_changed")

func take_damage(damage):
	var health = current_health
	health -= damage
	set_current_health(health)
	
func set_current_health(health):
	current_health = health
	if current_health <= 0:
		emit_signal("no_health")
		current_health = 0
	if current_health >= max_health:
		current_health = max_health

func get_current_health():
	return current_health

func health():
	return current_health

func regen():
	if not regenerating:
		regenerating = true
		health_regen_timer.start()

func stop_regen():
	if regenerating:
		regenerating = false
		health_regen_timer.stop()

func regenerate_health():
	print("Regenerate Health")
	if current_health < max_health:
		var increment = float(max_health/100) * float(health_regen_per_level[level])
		current_health += increment
		emit_signal("health_increased", increment)
		if current_health > max_health:
			current_health = max_health
	
	
