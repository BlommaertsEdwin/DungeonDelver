extends KinematicBody2D

enum {
	MOVE,
	ATTACK,
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
var stats = PlayerStats

func _ready():
	stats.connect("no_health", self, "player_death")
	stats.connect("health_changed", self, "health_changed")
	animation_tree.active = true
	$Label.text = str(PlayerStats.max_health)

# IMPUT
func _unhandled_input(event):
	if event.is_action_pressed("move"):
		moving = true
		destination = get_global_mouse_position()
	if event.is_action_pressed("attack"):
		state = ATTACK


func _physics_process(delta):
	match state:
		MOVE:
			MovementLoop(delta)
		ATTACK:
			AttackLoop((delta))
# MOVEMENT 
func MovementLoop(delta):
	if moving == false:
		animation_state.travel("IDLE")
		speed = 0
	else:
		animation_tree.set("parameters/IDLE/blend_position", movement)
		animation_tree.set("parameters/WALK/blend_position", movement)
		animation_tree.set("parameters/ATTACK/blend_position", movement)
		animation_state.travel("WALK")
		speed += acceleration * delta
		if speed >= max_speed:
			speed = max_speed
	movement = position.direction_to(destination) * speed
	if position.distance_to(destination) > 5:
		movement = move_and_slide(movement)
	else:
		moving = false

func AttackLoop(delta):
#	movement = Vector2.ZERO
	speed = 0
	animation_state.travel("ATTACK")

func AttackAnimationFinished():
	state = MOVE

func _on_HurtBox_area_entered(area):
	stats.take_damage(area.damage)
	
func _on_HurtBox_body_entered(body):
	stats.take_damage(body.damage)
	body.queue_free()
	
func player_death():
	queue_free()
	
func health_changed(health):
	label.text = str(health)
	




