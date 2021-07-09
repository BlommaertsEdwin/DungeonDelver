extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var can_attack = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func can_attack_player():
	return can_attack

func _on_AttackZone_body_entered(body):
	can_attack = true

func _on_AttackZone_body_exited(body):
	can_attack = false
