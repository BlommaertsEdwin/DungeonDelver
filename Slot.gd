extends Panel

enum slot_categories {HEAD, BELT, SHOULDERS, CHEST, TROUSERS, 
BOOTS, WEAPON_LEFT, WEAPON_RIGHT, BRACERS, BACK, INVENTORY, GLOVES}

var slot_category = null


var default_tex = preload("res://Sprites/item_slot_default_background.png")
var empty_tex = preload("res://Sprites/item_slot_empty_background.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null

var ItemClass = preload("res://Items.tscn")
var item = null

func _ready():
	default_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style = StyleBoxTexture.new()
	empty_style.texture = empty_tex
	refresh_style()
	
func refresh_style():
	if item == null:
		set('custom_styles/panel', empty_style)
	else:
		set('custom_styles/panel', default_style)

func pickFromSlot():
	remove_child(item)
	var inventoryNode = find_parent('Inventory')
	inventoryNode.add_child(item)
	item = null
	refresh_style()
	
func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(1,1)
	var inventoryNode = find_parent('Inventory')
	print(item.drop_item)
	if item.drop_item:
		print("Test")
		item.drop_item = false
	else:
		inventoryNode.remove_child(item)
	add_child(item)
	refresh_style()
	
	
