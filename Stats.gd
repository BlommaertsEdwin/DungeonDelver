extends Node

# HEALTH
export var max_health = 10.0
onready var current_health = max_health setget set_current_health, get_current_health
signal no_health
signal health_increased(health)
signal mana_increased(mana)
export var regenerating = false
export var regenerating_mana = false
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


# MANA
export var max_mana = 10.0 setget set_max_mana, get_max_mana
onready var current_mana = get_max_mana() setget set_current_mana, get_current_mana
var mana_regen_timer
export var mana_regen_tick = 2

# STENGTH, AGILITY, INTELIGENCE, WISDOM
export var strength = 5.0 setget set_strength, get_strength
export var agility = 5.0 setget set_agility, get_agility
export var inteligence = 5.0 setget set_inteligence, get_inteligence
export var wisdom = 5.0 setget set_wisdom, get_wisdom

# EXPERIENCE, LEVEL
signal experience_changed
signal experience_required_changed
signal level_changed
export var experience_pool = 0
export var experience_required = 200 setget set_experience_required
export var experience_points = 100
export var level = 1 setget set_level

func _ready():
	health_regen_timer = Timer.new()
	health_regen_timer.wait_time = health_regen_tick
	health_regen_timer.connect("timeout", self, "regenerate_health")
	health_regen_timer.one_shot = false
	add_child(health_regen_timer)
	
	mana_regen_timer = Timer.new()
	mana_regen_timer.wait_time = mana_regen_tick
	mana_regen_timer.connect("timeout", self, "regenerate_mana")
	mana_regen_timer.one_shot = false
	add_child(mana_regen_timer)
	
func set_strength(new_strength):
	strength = new_strength

func get_strength():
	return strength
	
func set_agility(new_agility):
	agility = new_agility

func get_agility():
	return agility

func set_inteligence(new_inteligence):
	inteligence = new_inteligence

func get_inteligence():
	return inteligence
	
func set_wisdom(new_wisdom):
	wisdom = new_wisdom

func get_wisdom():
	return wisdom

func set_experience_pool(experience):
	print("Hopla3")
	experience_pool += experience
	print(experience_pool)
	emit_signal("experience_changed")
	
func set_experience_required(experience_req):
	experience_required = experience_req
	emit_signal("experience_required_changed")
	
func set_level(level_increase):
	level += level_increase
	emit_signal("level_changed")

func take_damage(damage):
	var health = current_health
	health -= damage
	set_current_health(health)
	
func spend_mana(mana):
	var manapool = current_mana
	manapool -= mana
	if !manapool < 0:
		set_current_mana(manapool)
		mana_regen()
		return true
	else:
		return false
		
func set_current_health(health):
	current_health = health
	if current_health <= 0:
		emit_signal("no_health")
		current_health = 0
	if current_health > max_health:
		current_health = max_health

func get_current_health():
	return current_health
	
func set_current_mana(mana):
	current_mana = mana
	if current_mana <= 0:
		emit_signal("no_mana")
		current_mana = 0
	if current_mana > get_max_mana():
		set_max_mana(get_max_mana())
		

func get_current_mana():
	return current_mana
	
func set_max_mana(mana):
	max_mana = mana

func get_max_mana():
	var new_max_mana = max_mana + ((max_mana / 100) * inteligence)
	return new_max_mana
	
func mana_regen():
	if not regenerating_mana:
		regenerating_mana = true
		mana_regen_timer.start()

func stop_mana_regen():
	if regenerating_mana:
		regenerating_mana = false
		mana_regen_timer.stop()

func regenerate_mana():
	if current_mana < max_mana:
		var increment = float(get_max_mana()/100) * float(wisdom)
		current_mana += increment
		emit_signal("mana_increased", increment)
		if current_mana >= get_max_mana():
			set_current_mana(get_max_mana())


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
	if current_health < max_health:
		var increment = float(max_health/100) * float(health_regen_per_level[level])
		current_health += increment
		emit_signal("health_increased", increment)
		if current_health > max_health:
			current_health = max_health

func gain_experience(experience_gained):
	set_experience_pool(experience_gained)
	while experience_pool >= experience_required:
		LevelUp()
		experience_pool -= experience_required

func LevelUp():
	level += 1
