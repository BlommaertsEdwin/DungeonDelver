extends KinematicBody2D
onready var stats = $Stats
enum {
	IDLE,
	CHASE,
	WANDER,
	MELEE_ATTACK,
	RANGE_ATTACK,
	DEAD,
	AOE_ATTACK
}
enum ATTACKTYPE {
	FIREBALL,
	GROUNDSLAM
}
var state = IDLE
var velocity = Vector2.ZERO
export var ACCELERATION = 250
export var MAXSPEED = 100
export var FRICTION = 200
onready var player_detection_zone = $PlayerDetectionZone
onready var attack_zone = $AttackZone
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var wander_controller = $WanderController
const fireball = preload("res://Enemies/FireBall.tscn")
const groundslam = preload("res://Enemies/GroundSlam.tscn")
var castbar = preload("res://CastBar.tscn")
onready var spawn_position = $SpawnPosition
var fireball_item = null
var groundslam_item = null
var castbarInstance = null
var cast_finished = false
var can_cast = true
onready var healthBar = $Healthbar

func _ready():
	animation_tree.active = true

func _take_damage(area):
	var damage = area.damage
	stats.take_damage(damage)
	healthBar.reduce_healthbar(stats.max_health, damage)

func _on_HurtBox_area_entered(area):
	_take_damage(area)
	if state == DEAD:
		area.enemy_dead(stats.experience_points)

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
			var hurtbox = $HurtBox/CollisionShape2D
			if castbarInstance != null:
				remove_child(castbarInstance)
				castbarInstance = null
			hurtbox.disabled = true
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
					state = AOE_ATTACK
			else:
				state = IDLE
			
		MELEE_ATTACK:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			animation_state.travel("IDLE")
			start_cast(ATTACKTYPE.GROUNDSLAM)
			if cast_finished and not attack_zone.can_attack_player():
				state = CHASE
				
		RANGE_ATTACK:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			animation_state.travel("IDLE")
			start_cast(ATTACKTYPE.FIREBALL)
			if cast_finished:
				state = CHASE
				
		AOE_ATTACK:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			animation_state.travel("IDLE")
			start_cast(ATTACKTYPE.GROUNDSLAM)
			
			
			
	velocity = move_and_slide(velocity)

func DeadLoop(delta):
	
	# Removed because when dead it doesn't need to move anymore.
	# velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	animation_state.travel("DEATH")

func seek_player():
	if player_detection_zone.can_see_player():
		var random = rand_range(1,10)
		if random <= 5 and cast_finished:
			state = CHASE
			can_cast = true
			cast_finished = false
		else:
			state = RANGE_ATTACK

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func start_cast(type):
	if type == ATTACKTYPE.FIREBALL:
		if castbarInstance == null and can_cast:
			castbarInstance = castbar.instance()
			castbarInstance.init(0.1)
			castbarInstance.connect("cast_finished", self, "_spawn_fireball")
			add_child(castbarInstance)
	elif type == ATTACKTYPE.GROUNDSLAM:
		if castbarInstance == null:
			castbarInstance = castbar.instance()
			castbarInstance.init(0.05)
			castbarInstance.connect("cast_finished", self, "_spawn_groundslam")
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

func _spawn_groundslam():
	if groundslam_item == null:
		groundslam_item = groundslam.instance()
		if player_detection_zone.player:
			var scene = get_tree().current_scene
			get_parent().remove_child(self)
			scene.add_child(self)
			spawn_position.add_child(groundslam_item)
		groundslam_item = null
		cast_finished = true
		castbarInstance = null
		can_cast = false
		state = CHASE
