extends Node2D
const bar_length = 40
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
	if line.points[1].x <= 0:
		line.points[1].x = 0
		
func increase_healthbar(max_health, healthpoints):
	print(max_health)
	var health_portion = float(healthpoints)/float(max_health)
	var heal_health = bar_length*health_portion
	print(heal_health)
	line.points[1].x += heal_health
	print(line.points[1].x)
	if line.points[1].x >= bar_length:
		line.points[1].x = bar_length
