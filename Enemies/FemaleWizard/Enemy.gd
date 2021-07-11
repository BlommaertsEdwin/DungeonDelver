extends KinematicBody2D
onready var stats = $Stats
onready var health_label = $Label
enum {
	IDLE,
	CHASE,
	WANDER,
	MELEE_ATTACK,
	RANGE_ATTACK,
	DEAD,
}
var state = IDLE
var velocity = Vector2.ZERO
export var ACCELERATION = 200
export var MAXSPEED = 50
export var FRICTION = 200
onready var player_detection_zone = $PlayerDetectionZone
onready var attack_zone = $AttackZone
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var wander_controller = $WanderController
const fireball = preload("res://Enemies/FireBall.tscn")
var castbar = preload("res://CastBar.tscn")
onready var spawn_position = $SpawnPosition
var fireball_item = null
var castbarInstance = null
var cast_finished = false
var can_cast = true
onready var healthBar = $Healthbar

func _ready():
	animation_tree.active = true

func _take_damage(damage):
	stats.take_damage(damage)
	healthBar.reduce_healthbar(stats.max_health, damage)

func _on_HurtBox_area_entered(area):
	_take_damage(area.damage)

func _on_Stats_no_health():
	state = DEAD
#	queue_free()

func _physics_process(delta):
	match state:
		DEAD:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			animation_tree.set("parameters/IDLE/blend_position", velocity)
			animation_tree.set("parameters/WALK/blend_position", velocity)
			animation_tree.set("parameters/ATTACK/blend_position", velocity)
			animation_tree.set("parameters/DEATH/blend_position", velocity)
			remove_child(castbarInstance)
			animation_state.travel("DEATH")
#			DeadLoop(delta)
			
		IDLE:
			seek_player()
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			animation_tree.set("parameters/IDLE/blend_position", velocity)
			animation_tree.set("parameters/WALK/blend_position", velocity)
			animation_tree.set("parameters/ATTACK/blend_position", velocity)
			animation_tree.set("parameters/DEATH/blend_position", velocity)
			animation_state.travel("IDLE")
			if wander_controller.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wander_controller.set_wander_time(rand_range(4,6))
				
		WANDER:
			seek_player()
			if wander_controller.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wander_controller.set_wander_time(rand_range(4,6))
			var direction = global_position.direction_to(wander_controller.target_position)
			velocity = velocity.move_toward(direction * MAXSPEED, ACCELERATION * delta)
			animation_tree.set("parameters/IDLE/blend_position", velocity)
			animation_tree.set("parameters/WALK/blend_position", velocity)
			animation_tree.set("parameters/ATTACK/blend_position", velocity)
			animation_tree.set("parameters/DEATH/blend_position", velocity)
			animation_state.travel("WALK")
			if global_position.distance_to(wander_controller.target_position) <= 4:
				state = pick_random_state([IDLE, WANDER])
				wander_controller.set_wander_time(rand_range(4,6))
				
		CHASE:
			var player = player_detection_zone.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAXSPEED, ACCELERATION * delta)
				animation_tree.set("parameters/IDLE/blend_position", velocity)
				animation_tree.set("parameters/WALK/blend_position", velocity)
				animation_tree.set("parameters/ATTACK/blend_position", velocity)
				animation_tree.set("parameters/DEATH/blend_position", velocity)
				animation_state.travel("WALK")
				if attack_zone.can_attack_player():
					state = MELEE_ATTACK
			else:
				state = IDLE
			
		MELEE_ATTACK:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			animation_state.travel("ATTACK")
			if not attack_zone.can_attack_player():
				state = CHASE
				
		RANGE_ATTACK:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			animation_state.travel("IDLE")
			start_cast()
			if cast_finished:
				state = CHASE
			
	velocity = move_and_slide(velocity)

func DeadLoop(delta):
	
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	animation_state.travel("DEATH")

func seek_player():
	if player_detection_zone.can_see_player():
		var random = rand_range(1,10)
		if random <= 5:
			state = CHASE
			can_cast = true
			cast_finished = false
		else:
			state = RANGE_ATTACK

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func start_cast():
	if castbarInstance == null and can_cast:
		castbarInstance = castbar.instance()
		castbarInstance.connect("cast_finished", self, "_spawn_fireball")
		add_child(castbarInstance)

func _spawn_fireball():
	if fireball_item == null:
		fireball_item = fireball.instance()
		if player_detection_zone.player:
			fireball_item.rotation = get_angle_to(player_detection_zone.player.global_position)
			var scene = get_tree().current_scene
			get_parent().remove_child(self)
			scene.add_child(self)
			spawn_position.add_child(fireball_item)
		fireball_item = null
		cast_finished = true
		castbarInstance = null
		can_cast = false
