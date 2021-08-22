extends Node2D

var item_name
var item_quantity
var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	var rand_val = rng.randi_range(0,13)
	print(rand_val)
	if rand_val == 0:
		item_name = "Iron Sword"
	elif rand_val == 1:
		item_name = "Tree Branch"
	elif rand_val == 2:
		item_name = "Barbarian Helmet"
	elif rand_val == 3:
		item_name = "Barbarian Shoulders"
	elif rand_val == 4:
		item_name = "Barbarian Chest"
	elif rand_val == 5:
		item_name = "Barbarian Trousers"
	elif rand_val == 6:
		item_name = "Barbarian Shoulders"
	elif rand_val == 7:
		item_name = "Barbarian Gloves"
	elif rand_val == 8:
		item_name = "Barbarian Bracers"
	elif rand_val == 9:
		item_name = "Barbarian Back"
	elif rand_val == 10:
		item_name = "Barbarian Belt"
	elif rand_val == 11:
		item_name = "Barbarian Shield"
	elif rand_val == 12:
		item_name = "Barbarian Boots"
	else:
		item_name = "Slime Potion"
	
	$TextureRect.texture = load("res://ItemIcons/" + item_name + ".png")
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	item_quantity = randi() % stack_size + 1
	
	if stack_size == 1:
		 $TextureRect/Label.visible = false
	else:
		 $TextureRect/Label.text = String(item_quantity)

func set_item(nm, qt):
	item_name = nm
	item_quantity = qt
	$TextureRect.texture = load("res://ItemIcons/" + item_name + ".png")
	
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		 $TextureRect/Label.visible = false
	else:
		 $TextureRect/Label.visible = true
		 $TextureRect/Label.text = String(item_quantity)
		
func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$TextureRect/Label.text = String(item_quantity)
	
func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$TextureRect/Label.text = String(item_quantity)
