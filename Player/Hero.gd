extends KinematicBody2D

enum {
	MOVE,
	ATTACK,
	DEAD,
}

var state = MOVE
# 24 33
const friction = 10
var speed = 0
var max_speed = 400 setget set_max_speed, get_max_speed
var acceleration = 150
var move_direction = 0
var moving = false
var destination = Vector2()
var movement = Vector2()
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var stats = PlayerStats
onready var healthBar = $Healthbar
onready var xp_bar = "../../GUI/ExperienceBar"
var agro = false

func set_max_speed(new_max_speed):
	speed = new_max_speed
	
func get_max_speed():
	var new_max_speed = max_speed + ((max_speed / 100) * stats.agility)
	return new_max_speed

func _ready():
	stats.connect("health_increased", self, "health_increased") 
	stats.connect("no_health", self, "player_death")
	animation_tree.active = true
	
# IMPUT
func _unhandled_input(event):
	if event.is_action_pressed("move"):
		moving = true
		destination = get_global_mouse_position()
	if event.is_action_pressed("attack") and state != DEAD:
		state = ATTACK


func _physics_process(delta):
	match state:
		MOVE:
			MovementLoop(delta)
		ATTACK:
			AttackLoop(delta)
		DEAD:
			DeadLoop(delta)
			
# MOVEMENT 
func MovementLoop(delta):
	if not agro:
		PlayerStats.regen()
	else:
		PlayerStats.stop_regen()
	if moving == false:
		animation_state.travel("IDLE")
		speed = 0
	else:
		animation_tree.set("parameters/IDLE/blend_position", movement)
		animation_tree.set("parameters/WALK/blend_position", movement)
		animation_tree.set("parameters/ATTACK/blend_position", movement)
		animation_tree.set("parameters/DEATH/blend_position", movement)
		animation_state.travel("WALK")
		speed += acceleration * delta
		if speed >= max_speed:
			speed = max_speed
	movement = position.direction_to(destination) * speed
	if position.distance_to(destination) > 5:
		movement = move_and_slide(movement)
	else:
		moving = false

func AttackLoop(_delta):
	PlayerStats.stop_regen()
	speed = 0
	animation_state.travel("ATTACK")
	
func DeadLoop(_delta):
	PlayerStats.stop_regen()
	speed = 0
	var collision = $CollisionShape2D
	collision.disabled = true
	animation_state.travel("DEATH")


func AttackAnimationFinished():
	state = MOVE

func _on_HurtBox_area_entered(area):
	player_takes_damage(area)

func _on_HurtBox_body_entered(body):
	player_takes_damage(body)
	body.queue_free()
	
func health_increased(health):
	healthBar.increase_healthbar(stats.max_health, health)
	
	
func player_takes_damage(area):
	stats.take_damage(area.damage)
	healthBar.reduce_healthbar(stats.max_health, area.damage)
	
func player_death():
	state = DEAD

func _on_SwordHitBox_killed_enemy(experience_gained):
	PlayerStats.gain_experience(experience_gained)

func _on_SkillBar_abilityUsed(ability_name, ability_cd):
	if state != DEAD:
		if ability_name == 'Slash':
			state = ATTACK
		elif ability_name == 'Buff':
			stats.strength += 100
			
		
func has_agro():
	agro = true
	
func lost_agro():
	agro = false
	
