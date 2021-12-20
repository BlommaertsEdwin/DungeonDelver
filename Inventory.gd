extends Node2D
const SlotClass = preload("res://Slot.gd")
const ItemClass = preload("res://Items.tscn")
onready var inventory_slots = $GridContainer
onready var equip_slots_left = $EquipSlotLeft
onready var equip_slots_right = $EquipSlotRight
onready var equip_slot_bottom = $EquipSlotBottom
var holding_item = null


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$StatsLabel.text = "-strength: %s \n-agility: %s \n-inteligence: %s \n-wisdom %s\n------------\n\nhealth:%s\\%s\nmanapool:%s\\%s" % [PlayerStats.strength, PlayerStats.agility, PlayerStats.inteligence, PlayerStats.wisdom, PlayerStats.current_health, PlayerStats.max_health, PlayerStats.current_mana, PlayerStats.max_mana]
	for inventory_slot in inventory_slots.get_children():
		inventory_slot.connect("gui_input", self, "slot_gui_input", [inventory_slot])
		inventory_slot.slot_category = SlotClass.slot_categories.INVENTORY
		
	var equip_slots  = equip_slots_left.get_children() + equip_slots_right.get_children() + equip_slot_bottom.get_children()
	for i in range(equip_slots.size()):
		equip_slots[i].connect("gui_input", self, "slot_gui_input", [equip_slots[i]])
	# LEFT SIDE
	equip_slots[0].slot_category = SlotClass.slot_categories.HEAD
	equip_slots[1].slot_category = SlotClass.slot_categories.SHOULDERS
	equip_slots[2].slot_category = SlotClass.slot_categories.BACK
	equip_slots[3].slot_category = SlotClass.slot_categories.CHEST
	equip_slots[4].slot_category = SlotClass.slot_categories.BELT
	# RIGHT SIDE
	equip_slots[5].slot_category = SlotClass.slot_categories.TROUSERS
	equip_slots[6].slot_category = SlotClass.slot_categories.BOOTS
	equip_slots[7].slot_category = SlotClass.slot_categories.BRACERS
	equip_slots[8].slot_category = SlotClass.slot_categories.GLOVES
	# BOTTOM
	equip_slots[9].slot_category = SlotClass.slot_categories.WEAPON_RIGHT
	equip_slots[10].slot_category = SlotClass.slot_categories.WEAPON_LEFT
		
func _is_able_to_be_put_into_slot(slot: SlotClass):
	if holding_item:
		var holding_item_category = str(JsonData.item_data[holding_item.item_name]["ItemCategory"])
		if slot.slot_category == slot.slot_categories.HEAD:
			if holding_item_category == "HEAD":
				$PaperDoll.add_to_equipment_slot(slot.slot_category, holding_item)
				return true
		if slot.slot_category == slot.slot_categories.WEAPON_LEFT:
			if holding_item_category == "WEAPON_LEFT":
				$PaperDoll.add_to_equipment_slot(slot.slot_category, holding_item)
				return true
		if slot.slot_category == slot.slot_categories.WEAPON_RIGHT:
			if holding_item_category == "WEAPON_RIGHT":
				$PaperDoll.add_to_equipment_slot(slot.slot_category, holding_item)
				return true
		if slot.slot_category == slot.slot_categories.BRACERS:
			if holding_item_category == "BRACERS":
				$PaperDoll.add_to_equipment_slot(slot.slot_category, holding_item)
				return true
		if slot.slot_category == slot.slot_categories.BOOTS:
			if holding_item_category == "BOOTS":
				$PaperDoll.add_to_equipment_slot(slot.slot_category, holding_item)
				return true
		if slot.slot_category == slot.slot_categories.SHOULDERS:
			if holding_item_category == "SHOULDERS":
				$PaperDoll.add_to_equipment_slot(slot.slot_category, holding_item)
				return true
		if slot.slot_category == slot.slot_categories.CHEST:
			if holding_item_category == "CHEST":
				$PaperDoll.add_to_equipment_slot(slot.slot_category, holding_item)
				return true
		if slot.slot_category == slot.slot_categories.TROUSERS:
			if holding_item_category == "TROUSERS":
				$PaperDoll.add_to_equipment_slot(slot.slot_category, holding_item)
				return true
		if slot.slot_category == slot.slot_categories.BACK:
			if holding_item_category == "BACK":
				$PaperDoll.add_to_equipment_slot(slot.slot_category, holding_item)
				return true
		if slot.slot_category == slot.slot_categories.BELT:
			if holding_item_category == "BELT":
				$PaperDoll.add_to_equipment_slot(slot.slot_category, holding_item)
				return true
		if slot.slot_category == slot.slot_categories.GLOVES:
			if holding_item_category == "GLOVES":
				$PaperDoll.add_to_equipment_slot(slot.slot_category, holding_item)
				return true
		if slot.slot_category == slot.slot_categories.INVENTORY:
			return holding_item_category in ["RESOURCE", "CONSUMABLE", "WEAPON_LEFT",
			 "HEAD", "BELT", "SHOULDERS", "CHEST", "TROUSERS", "BOOTS", "WEAPON_RIGHT",
			 "BRACERS", "BACK", "GLOVES"]
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
				if slot.slot_category != SlotClass.slot_categories.INVENTORY:
					$PaperDoll.remove_from_equipment_slot(slot.slot_category)
				holding_item.global_position = get_global_mouse_position()
				
func _input(_event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()


func _on_Hero_picked_up_item(item):
	var new_item = ItemClass.instance()
	new_item.set_item(item.name, 1,item.drop_item )
	for inventory_slot in inventory_slots.get_children():
		if inventory_slot.item == null:
			inventory_slot.putIntoSlot(new_item)
		break

