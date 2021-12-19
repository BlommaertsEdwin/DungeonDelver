extends "res://HitHurtBoxes/HitBox.gd"
signal killed_enemy(experience_gained)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func enemy_dead(experience_gained):
	print("hopla!")
	print(experience_gained)
	emit_signal("killed_enemy",experience_gained)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
