extends KinematicBody2D


const ACCELERATION = 460
const MAX_SPEED = 225
var velocity = Vector2.ZERO
var item_name
var player = null
var being_picked_up = false

func _ready():
	item_name = "Slime Potion"
	
func pick_up_item(body):
	player = body
	being_picked_up = true

func _physics_process(delta):
	if being_picked_up:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		var distance = global_position.distance_to(player.global_position)
		if distance < 4:
			queue_free()
	velocity = move_and_slide(velocity, Vector2.UP)
