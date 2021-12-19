extends CanvasLayer


onready var xp_bar = $ExperienceBar/ExperienceBar
var stats = PlayerStats

# Called when the node enters the scene tree for the first time.
func _ready():
	set_experiencebar()
	stats.connect("experience_changed", self, "experience_changed")
	stats.connect("level_changed", self, "level_changed")

func experience_changed():
	set_experiencebar()

func level_changed():
	pass


# Set the max value and current experience of the experience bar
func set_experiencebar():
	xp_bar.max_value = PlayerStats.experience_required
	xp_bar.value = PlayerStats.experience_pool

# Sets the Inventory screen to be visible or invisible
# The I key is linked to the inventory action
func _unhandled_input(event):
	if event.is_action_pressed("inventory") and !$Inventory.visible:
		print("pressed invisible")
		$Inventory.visible = true
	elif event.is_action_pressed("inventory") and $Inventory.visible:
		print("pressed visible")
		$Inventory.visible = false
