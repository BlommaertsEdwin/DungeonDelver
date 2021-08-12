extends PopupDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PopupDialog_about_to_show():
	$Label.text = "-strength: %s \n-agility: %s \n-inteligence: %s \n-wisdom %s\n------------\n\nhealth:%s\\%s\nmanapool:%s\\%s" % [PlayerStats.strength, PlayerStats.agility, PlayerStats.inteligence, PlayerStats.wisdom, PlayerStats.current_health, PlayerStats.max_health, PlayerStats.current_mana, PlayerStats.max_mana]
