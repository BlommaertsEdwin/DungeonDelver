extends Control
onready var buttons_path = "Background/HBoxContainer"
var loadedSkills = {
	"AbilityButton1": {"name": "Slash", "cooldown": 1}, 
	"AbilityButton2": {"name": "ShieldWall", "cooldown": 1},
	"AbilityButton3": {"name": "ShieldWall", "cooldown": 1}
	}
	
signal abilityUsed(ability_name, ability_cd)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var UiButtons = get_tree().get_nodes_in_group("UiButtons")
	for MainButton in UiButtons:
		MainButton.connect("pressed", self, "SelectButton", [MainButton.get_parent().get_name()])
		for OtherButton in UiButtons:
			if MainButton != OtherButton and OtherButton.on_the_gcd:
				MainButton.connect("gcd_triggered", OtherButton, "gcd_triggered")
			
func LoadSkills():
	pass

func SelectButton(PressedButton):
	var action = loadedSkills[PressedButton]['name']
	var cooldown = loadedSkills[PressedButton]['cooldown']
	emit_signal("abilityUsed", action, cooldown)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
