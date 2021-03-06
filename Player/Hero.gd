extends KinematicBody2D
signal picked_up_item(item_name)

enum {
	MOVE,
	ATTACK,
	DEAD,
}

var state = MOVE
# 24 33
const friction = 10
var speed = 0
var max_speed = 400 setget set_max_speed, get_max_speed
var acceleration = 150
var move_direction = 0
var moving = false
var destination = Vector2()
var movement = Vector2()
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var stats = PlayerStats
onready var healthBar = $Healthbar
onready var manaBar = $Manabar
#onready var xp_bar = "../../GUI/ExperienceBar"
var agro = false
const SlotClass = preload("res://Slot.gd")
#onready var sprite = get_node(NodePath("GUI/Inventory/PaperDoll/DollSprite"))

func set_max_speed(new_max_speed):
	speed = new_max_speed
	
func get_max_speed():
	var new_max_speed = max_speed + ((max_speed / 100.0) * stats.agility)
	return new_max_speed

func _ready():
	stats.connect("health_increased", self, "health_increased") 
	stats.connect("mana_increased", self, "mana_increased")
	stats.connect("no_health", self, "player_death")
	animation_tree.active = true
#	$Sprite2.texture = sprite.texture
	
# INPUT
func _unhandled_input(event):
	if event.is_action_pressed("move") and state != DEAD:
		moving = true
		destination = get_global_mouse_position()
	if event.is_action_pressed("attack") and state != DEAD:
		state = ATTACK
	if event.is_action_pressed("pickup") and state != DEAD:
		if $PickupZone.items_in_range.size() > 0:
			var pickup_item = $PickupZone.items_in_range.values()[0]
			emit_signal("picked_up_item", pickup_item)
			pickup_item.pick_up_item(self)
			$PickupZone.items_in_range.erase(pickup_item)	


func _physics_process(delta):
	match state:
		MOVE:
			MovementLoop(delta)
		ATTACK:
			AttackLoop(delta)
		DEAD:
			DeadLoop(delta)
			
# MOVEMENT 
func MovementLoop(delta):
	if not agro:
		PlayerStats.regen()
	else:
		PlayerStats.stop_regen()
	if moving == false:
		animation_state.travel("IDLE")
		speed = 0
	else:
		animation_tree.set("parameters/IDLE/blend_position", movement)
		animation_tree.set("parameters/WALK/blend_position", movement)
		animation_tree.set("parameters/ATTACK/blend_position", movement)
		animation_tree.set("parameters/DEATH/blend_position", movement)
		animation_state.travel("WALK")
		speed += acceleration * delta
		if speed >= max_speed:
			speed = max_speed
	movement = position.direction_to(destination) * speed
	if position.distance_to(destination) > 5:
		movement = move_and_slide(movement)
	else:
		moving = false

func AttackLoop(_delta):
	PlayerStats.stop_regen()
	speed = 0
	animation_state.travel("ATTACK")
	
func DeadLoop(_delta):
	PlayerStats.stop_regen()
	speed = 0
	var collision = $CollisionShape2D
	collision.disabled = true
	animation_state.travel("DEATH")


func AttackAnimationFinished():
	state = MOVE

func _on_HurtBox_area_entered(area):
	player_takes_damage(area)

func _on_HurtBox_body_entered(body):
	player_takes_damage(body)
	body.queue_free()
	
func health_increased(health):
	healthBar.increase_healthbar(stats.max_health, health)
	
func mana_increased(mana):
	manaBar.increase_manabar(stats.get_max_mana(), mana)
	
func player_takes_damage(area):
	stats.take_damage(area.damage)
	healthBar.reduce_healthbar(stats.max_health, area.damage)
	
func player_death():
	state = DEAD

func _on_SwordHitBox_killed_enemy(experience_gained):
	print("hopla2")
	PlayerStats.gain_experience(experience_gained)

func _on_SkillBar_abilityUsed(ability_name):
	if state != DEAD:
		if ability_name == 'Slash':
			state = ATTACK
		elif ability_name == 'Buff':
			ability_strengthbuff()

func has_agro():
	agro = true
	
func lost_agro():
	agro = false
	
func spend_mana(mana):
	var allowed = stats.spend_mana(mana)
	if allowed:
		manaBar.reduce_manabar(stats.max_mana, mana)
	return allowed

func ability_strengthbuff():
	if spend_mana(5):
		stats.strength += 100
		$Buffbar/HBoxContainer/Node2D/Strengthbuff.visible = true
		yield(get_tree().create_timer(3), "timeout")
		stats.strength -= 100
		$Buffbar/HBoxContainer/Node2D/Strengthbuff.visible = false

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


func _on_PaperDoll_add_item_to_equipment_slot(category, new_item):
	if SlotClass.slot_categories.HEAD == category:
		$HeadSlotSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")
	if SlotClass.slot_categories.SHOULDERS == category:
		$ShoulderSlotSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")
	if SlotClass.slot_categories.CHEST == category:
		$ChestSlotSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")
	if SlotClass.slot_categories.TROUSERS == category:
		$TrouserSlotSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")
	if SlotClass.slot_categories.BOOTS == category:
		$BootSlotSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")
	if SlotClass.slot_categories.BRACERS == category:
		$BracerSlotSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")
	if SlotClass.slot_categories.GLOVES == category:
		$GlovesSlotSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")
	if SlotClass.slot_categories.BELT == category:
		$BeltSlotSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")
	if SlotClass.slot_categories.BACK == category:
		$BackSlotSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")
	if SlotClass.slot_categories.WEAPON_RIGHT == category:
		$WeaponSlotLeftSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name + ".png")
	if SlotClass.slot_categories.WEAPON_LEFT == category:
		$WeaponSlotRightSprite.texture = load("res://CharacterSpriteSheets/" + new_item.item_name +".png")
	else:
		pass # Replace with function body.


func _on_PaperDoll_remove_item_from_equipment_slot(category):
	if SlotClass.slot_categories.HEAD == category:
		$HeadSlotSprite.texture = null
	if SlotClass.slot_categories.SHOULDERS == category:
		$ShoulderSlotSprite.texture = null
	if SlotClass.slot_categories.CHEST == category:
		$ChestSlotSprite.texture = null
	if SlotClass.slot_categories.TROUSERS == category:
		$TrouserSlotSprite.texture = null
	if SlotClass.slot_categories.BOOTS == category:
		$BootSlotSprite.texture = null
	if SlotClass.slot_categories.BRACERS == category:
		$BracerSlotSprite.texture = null
	if SlotClass.slot_categories.GLOVES == category:
		$GlovesSlotSprite.texture = null
	if SlotClass.slot_categories.BELT == category:
		$BeltSlotSprite.texture = null
	if SlotClass.slot_categories.BACK == category:
		$BackSlotSprite.texture = null
	if SlotClass.slot_categories.WEAPON_RIGHT == category:
		$WeaponSlotLeftSprite.texture = null
	if SlotClass.slot_categories.WEAPON_LEFT == category:
		$WeaponSlotRightSprite.texture = null
	else:
		pass
