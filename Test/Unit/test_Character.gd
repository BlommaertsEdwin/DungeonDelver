extends "res://addons/gut/test.gd"

var Character = load("res://Player/Hero.tscn")
var Enemy = load("res://Enemies/FemaleWizard/Enemy.tscn")
var PlayerStat = load("res://Stats.gd")
var FireBall = load("res://Enemies/FemaleWizard/FireBall.gd")

var _char = null
var _fireball = null

func before_each():
	print("before")
	_char = Character.instance()
	add_child_autoqfree(_char)
	_fireball = FireBall.new()

func test_1_has_agro():
	var result = _char.has_agro()
	assert_true(_char.agro)
	
func test_2_lost_agro():
	var result = _char.lost_agro()
	assert_false(_char.agro)
	
func test_3_default_player_stats():
	assert_not_null(_char.stats)
	assert_is(_char.stats, PlayerStat)
	assert_eq(_char.stats.max_health, 10.0)
	assert_setget(_char.stats, 'strength', 'set_strength', 'get_strength')
	assert_setget(_char.stats, 'agility', 'set_agility', 'get_agility')
	assert_setget(_char.stats, 'inteligence', 'set_inteligence', 'get_inteligence')
	assert_setget(_char.stats, 'wisdom', 'set_wisdom', 'get_wisdom')
	
func test_5_take_damage_from_fireball():
	_char.stats.current_health = 10.0
	_char.player_takes_damage(_fireball)
	assert_eq(_char.stats.current_health, _char.stats.max_health - _fireball.damage)
	
func test_6_regenerate_health():
	_char.player_takes_damage(_fireball)
	var health_before_regen = _char.stats.current_health
	_char.stats.regenerate_health()
	var health_after_regen = _char.stats.current_health
	assert_lt(health_before_regen, health_after_regen)
	
func test_7_experience_gain():
	var experience = 250
	var experience_required = 200
	var level = 1
	_char.stats.level = level
	_char.stats.experience_required = experience_required
	_char.stats.gain_experience(experience)
	assert_eq(_char.stats.experience_pool, experience - experience_required)
	assert_eq(_char.stats.level, 2)
	
func test_8_reduce_enemy_health():
	var _enemy = Enemy.instance()
	add_child_autoqfree(_enemy)
	var starting_health = _enemy.stats.current_health
	_enemy._take_damage(_fireball)
	assert_lt(_enemy.stats.current_health, starting_health)

func test_9_set_max_mana():
	var max_mana = _char.stats.max_mana
	var current_mana = _char.stats.current_mana
	var calc_max_mana = 10.0 + ((10.0 / 100.0) * _char.stats.inteligence)
	assert_eq(max_mana, calc_max_mana)
	assert_eq(max_mana, current_mana)
	
func test_10_spend_mana():
	var mana_to_spend = 5
	_char.stats.spend_mana(mana_to_spend)
	var max_mana = _char.stats.max_mana
	var current_mana = _char.stats.current_mana
	assert_eq(current_mana, max_mana - mana_to_spend)
	
