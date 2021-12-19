extends TextureButton
onready var time_label = $Counter/Value
export var cooldown = 3 setget set_cooldown, get_cooldown
export var gcd = 1.0
export var on_the_gcd = true
signal gcd_triggered

func set_cooldown(new_cooldown):
	cooldown = new_cooldown

func get_cooldown():
	var new_cool_down = cooldown - ((cooldown / 100) * PlayerStats.agility)
	return new_cool_down

func _ready():
	$Sweep/Timer.wait_time = cooldown
	$Sweep.texture_progress = texture_normal
	$Sweep.value = 0
	$GcdSweep/GcdTimer.wait_time = gcd
	$GcdSweep.texture_progress = texture_normal
	$GcdSweep.value = 0
	time_label.hide()
	set_process(false)

func _process(_delta):
	time_label.text = "%3.1f" % $Sweep/Timer.time_left
	$Sweep.value = ($Sweep/Timer.time_left / get_cooldown()) * 100
	$GcdSweep.value = ($GcdSweep/GcdTimer.time_left / gcd) * 100

func gcd_triggered():
	if not disabled:
		$GcdSweep/GcdTimer.start()
		disabled = true
		set_process(true)

func _on_AbilityButton_pressed():
	emit_signal("gcd_triggered")
	disabled = true
	set_process(true)
	$Sweep/Timer.start()
	time_label.show()

func _on_Timer_timeout():
	$Sweep.value = 0
	disabled = false
	time_label.hide()
	set_process(false)

func _on_GcdTimer_timeout():
	$GcdSweep.value = 0
	disabled = false
	set_process(false)
