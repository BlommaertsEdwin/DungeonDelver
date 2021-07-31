extends RigidBody2D

const CAST_VELOCITY = Vector2(400, 0)
var velocity = Vector2.ZERO
export var lifetime = 10
export var damage = 5
var angle = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	launch_fireball()
	
	
func launch_fireball():
	apply_impulse(Vector2(), Vector2(CAST_VELOCITY).rotated(rotation))
	angle = Vector2(CAST_VELOCITY).rotated(rotation)
	
func self_destruct():
	yield(get_tree().create_timer(lifetime), "timeout")
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_FireBall_body_entered(_body):
	queue_free() # Replace with function body.
