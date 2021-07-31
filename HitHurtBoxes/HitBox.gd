extends Area2D

export var damage = 1.0 setget set_damage, get_damage
signal target_dead

func get_damage():
	var weapon_damage = damage + ((damage / 100) * PlayerStats.strength)
	return weapon_damage
	
func set_damage(weapon_damage):
	damage = weapon_damage

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func player_dead():
	emit_signal("target_dead")
	
	
#	playerDetectionZone.player = null
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
