extends TextureRect
signal removed_from_equipment_slot(category)
signal added_to_equipment_slot(category, item_name)


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const SlotClass = preload("res://Slot.gd")


func set(_texture, value):
	_texture = value


# Called when the node enters the scene tree for the first time.
func _ready():
	$DollSprite.texture = load("res://CharacterSpriteSheets/PaperDollSpriteSheet.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _add_to_headslot(new_item):
	$HeadSlotSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")
func _add_to_shoulderslot(new_item):
	$ShoulderSlotSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")
func _add_to_chestslot(new_item):
	$ChestSlotSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")
func _add_to_trouserslot(new_item):
	$TrouserSlotSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")
func _add_to_bootslot(new_item):
	$BootSlotSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")
func _add_to_beltslot(new_item):
	$BeltSlotSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")
func _add_to_bracerslot(new_item):
	$BracerSlotSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")
func _add_to_backslot(new_item):
	$BackSlotSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")
func _add_to_gloveslot(new_item):
	$GloveSlotSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")
func _add_to_weaponleftslot(new_item):
	$WeaponSlotLeftSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")
func _add_to_weaponrightslot(new_item):
	$WeaponSlotRightSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")

func remove_from_equipment_slot(slot_category):
	print("slotcategory")
	print(slot_category)
	emit_signal("removed_from_equipment_slot", slot_category)
	if slot_category == SlotClass.slot_categories.HEAD:
		$HeadSlotSprite.texture = null
	elif slot_category == SlotClass.slot_categories.SHOULDERS:
		$ShoulderSlotSprite.texture = null
	elif slot_category == SlotClass.slot_categories.CHEST:
		$ChestSlotSprite.texture = null
	elif slot_category == SlotClass.slot_categories.BELT:
		$BeltSlotSprite.texture = null
	elif slot_category == SlotClass.slot_categories.TROUSERS:
		$TrouserSlotSprite.texture = null
	elif slot_category == SlotClass.slot_categories.BOOTS:
		$BootSlotSprite.texture = null
	elif slot_category == SlotClass.slot_categories.BACK:
		$BackSlotSprite.texture = null
	elif slot_category == SlotClass.slot_categories.BRACERS:
		$BracerSlotSprite.texture = null
	elif slot_category == SlotClass.slot_categories.GLOVES:
		$GloveSlotSprite.texture = null
	elif slot_category == SlotClass.slot_categories.WEAPON_RIGHT:
		$WeaponSlotRightSprite.texture = null
	elif slot_category == SlotClass.slot_categories.WEAPON_LEFT:
		$WeaponSlotLeftSprite.texture = null
	else:
		pass
	
func add_to_equipment_slot(slot_category, item):
	if slot_category == SlotClass.slot_categories.HEAD:
		_add_to_headslot(item)
	elif slot_category == SlotClass.slot_categories.SHOULDERS:
		_add_to_shoulderslot(item)
	elif slot_category == SlotClass.slot_categories.CHEST:
		_add_to_chestslot(item)
	elif slot_category == SlotClass.slot_categories.BELT:
		_add_to_beltslot(item)
	elif slot_category == SlotClass.slot_categories.TROUSERS:
		_add_to_trouserslot(item)
	elif slot_category == SlotClass.slot_categories.BOOTS:
		_add_to_bootslot(item)
	elif slot_category == SlotClass.slot_categories.BACK:
		_add_to_backslot(item)
	elif slot_category == SlotClass.slot_categories.BRACERS:
		_add_to_bracerslot(item)
	elif slot_category == SlotClass.slot_categories.GLOVES:
		_add_to_gloveslot(item)
	elif slot_category == SlotClass.slot_categories.WEAPON_RIGHT:
		_add_to_weaponrightslot(item)
	elif slot_category == SlotClass.slot_categories.WEAPON_LEFT:
		_add_to_weaponleftslot(item)
	else:
		pass
	emit_signal("added_to_equipment_slot", slot_category, item)
	
	
	

	
