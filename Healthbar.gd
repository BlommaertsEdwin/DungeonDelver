extends Node2D
const bar_length = 50
onready var line = $Line2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func reduce_healthbar(max_health, damage):
	var health_portion = float(damage)/float(max_health)
	var damage_health = bar_length*health_portion
	line.points[1].x -= damage_health
