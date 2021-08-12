extends Node2D
const bar_length = 40
onready var line = $Line2D


func reduce_manabar(max_mana, mana_used):
	var mana_portion = float(mana_used)/float(max_mana)
	print("====start====")
	print(mana_portion)
	var mana_reduced = bar_length*mana_portion
	print(mana_reduced)
	line.points[1].x -= mana_reduced
	print(line.points[1].x)
	if line.points[1].x <= 0:
		line.points[1].x = 0
		
func increase_manabar(max_mana, mana_gained):
	var mana_portion = float(mana_gained)/float(max_mana)
	var mana_regained = bar_length*mana_portion
	line.points[1].x += mana_regained
	if line.points[1].x >= bar_length:
		line.points[1].x = bar_length
