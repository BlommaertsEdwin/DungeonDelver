extends Area2D
var player = null

func can_see_player():
	return player != null

func _on_PlayerDetectionZone_body_entered(body):
	player = body

func _on_PlayerDetectionZone_body_exited(_body):
	player = null

func _on_StaffHitBox_target_dead():
	player = null
