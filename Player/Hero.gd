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
var max_speed = 400
var acceleration = 150
var move_direction = 0
var moving = false
var destination = Vector2()
var movement = Vector2()
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var label = $Label
onready var stats = PlayerStats
onready var healthBar = $Healthbar

func _ready():
	stats.connect("no_health", self, "player_death")
	stats.connect("health_changed", self, "health_changed")
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
	speed = 0
	animation_state.travel("ATTACK")
	
func DeadLoop(_delta):
	speed = 0
	animation_state.travel("DEATH")
	
	
	
#	queue_free()

func AttackAnimationFinished():
	state = MOVE

func _on_HurtBox_area_entered(area):
	stats.take_damage(area.damage)
	healthBar.reduce_healthbar(stats.max_health, area.damage)

func _on_HurtBox_body_entered(body):
	stats.take_damage(body.damage)
	healthBar.reduce_healthbar(stats.max_health, body.damage)
	body.queue_free()
	
func player_death():
	state = DEAD


func _on_SwordHitBox_killed_enemy(experience_gained):
	print("Killed")
	PlayerStats.experience_pool += experience_gained
	while PlayerStats.experience_pool >= PlayerStats.experience_required:
		LevelUp()
		PlayerStats.experience_pool -= PlayerStats.experience_required
	print(experience_gained)
	print(PlayerStats.level)
	
func LevelUp():
	PlayerStats.level += 1
	# increase skill points
	# increase stats
	# increase 
	pass




func _on_SkillBar_abilityUsed(ability_name):
	if state != DEAD:
		state = ATTACK
