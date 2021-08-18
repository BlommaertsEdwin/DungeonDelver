extends Node2D
const SlotClass = preload("res://Slot.gd")
onready var inventory_slots = $GridContainer
onready var equip_slots_left = $EquipSlotLeft
onready var equip_slots_right = $EquipSlotRight
var holding_item = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	for inventory_slot in inventory_slots.get_children():
		inventory_slot.connect("gui_input", self, "slot_gui_input", [inventory_slot])
		inventory_slot.slot_category = SlotClass.slot_categories.INVENTORY
		
	var equip_slots  = equip_slots_left.get_children() + equip_slots_right.get_children()
	for i in range(equip_slots.size()):
		equip_slots[i].connect("gui_input", self, "slot_gui_input", [equip_slots[i]])
	equip_slots[0].slot_category = SlotClass.slot_categories.HEAD
	equip_slots[1].slot_category = SlotClass.slot_categories.NECK
	equip_slots[2].slot_category = SlotClass.slot_categories.SHOULDER
	equip_slots[3].slot_category = SlotClass.slot_categories.CHEST
	equip_slots[4].slot_category = SlotClass.slot_categories.TROUSER
	equip_slots[5].slot_category = SlotClass.slot_categories.BOOTS
	equip_slots[6].slot_category = SlotClass.slot_categories.CLOAK
	equip_slots[7].slot_category = SlotClass.slot_categories.WEAPON_LEFT
	equip_slots[8].slot_category = SlotClass.slot_categories.WEAPON_RIGHT
	
		
func _is_able_to_be_put_into_slot(slot: SlotClass):
	if holding_item:
		var holding_item_category = str(JsonData.item_data[holding_item.item_name]["ItemCategory"])
		if slot.slot_category == slot.slot_categories.HEAD:
			return holding_item_category == "HEAD"
		if slot.slot_category == slot.slot_categories.WEAPON_LEFT:
			return holding_item_category == "WEAPON_LEFT"
		if slot.slot_category == slot.slot_categories.WEAPON_RIGHT:
			return holding_item_category == "WEAPON_RIGHT"
		if slot.slot_category == slot.slot_categories.NECK:
			return holding_item_category == "NECK"
		if slot.slot_category == slot.slot_categories.BOOTS:
			return holding_item_category == "BOOTS"
		if slot.slot_category == slot.slot_categories.SHOULDER:
			return holding_item_category == "SHOULDER"
		if slot.slot_category == slot.slot_categories.CHEST:
			return holding_item_category == "CHEST"
		if slot.slot_category == slot.slot_categories.TROUSER:
			return holding_item_category == "TROUSER"
		if slot.slot_category == slot.slot_categories.CLOAK:
			return holding_item_category == "CLOAK"
		if slot.slot_category == slot.slot_categories.INVENTORY:
			return holding_item_category in ["RESOURCE", "CONSUMABLE", "WEAPON_LEFT"]
	return false

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			# Currently holding an Item
			if holding_item != null:
				# Empty slot
				if !slot.item:
					if _is_able_to_be_put_into_slot(slot):
						slot.putIntoSlot(holding_item)
						holding_item = null
				# Slot already contains an item	
				else:
					# Different item, so swap
					if holding_item.item_name != slot.item.item_name:
						if _is_able_to_be_put_into_slot(slot):
							var temp_item = slot.item
							slot.pickFromSlot()
							temp_item.global_position = event.global_position
							
							slot.putIntoSlot(holding_item)
							holding_item = temp_item
					# Same item, so try to merge
					else:
						if _is_able_to_be_put_into_slot(slot):
							var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
							var able_to_add = stack_size - slot.item.item_quantity
							if able_to_add >= holding_item.item_quantity:
								slot.item.add_item_quantity(holding_item.item_quantity)
								holding_item.queue_free()
								holding_item = null
							else:
								slot.item.add_item_quantity(able_to_add)
								holding_item.decrease_item_quantity(able_to_add)
			# Not holding an item				
			elif slot.item:
				holding_item = slot.item
				slot.pickFromSlot()
				holding_item.global_position = get_global_mouse_position()
				
func _input(event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()
