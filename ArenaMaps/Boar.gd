extends KinematicBody2D
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
enum {
	IDLE,
	CHASE,
	WANDER,
	MELEE_ATTACK,
	RANGE_ATTACK,
	DEAD,
	AOE_ATTACK
}
var state = IDLE
var velocity = Vector2.ZERO
export var ACCELERATION = 250
export var MAXSPEED = 100
export var FRICTION = 200
onready var animation_state = animation_tree.get("parameters/playback")
onready var player_detection_zone = $PlayerDetectionZone

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	match state:
			
		IDLE:
			seek_player()
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			animation_tree.set("parameters/IDLE/blend_position", velocity)
			animation_tree.set("parameters/CHASE/blend_position", velocity)
			animation_state.travel("IDLE")
#	
				
		CHASE:
			var player = player_detection_zone.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAXSPEED, ACCELERATION * delta)
				animation_tree.set("parameters/IDLE/blend_position", velocity)
				animation_tree.set("parameters/CHASE/blend_position", velocity)
				animation_state.travel("CHASE")
			else:
				state = IDLE
			
	velocity = move_and_slide(velocity)

func seek_player():
	if player_detection_zone.can_see_player():
		var random = rand_range(1,10)
		if random <= 5:
			state = CHASE
