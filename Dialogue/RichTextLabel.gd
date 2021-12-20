extends RichTextLabel
var dialog = ["Eeeeeek! Why are you naked?!", ["1. 'I don't know?'", "2. 'Go away!'", "3. Stay silent"]]
var page = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	set_bbcode(dialog[page])
	set_visible_characters(0)
	set_process_input(true)
	




func _on_Timer_timeout():
#	if event.type == InputEvent.
	set_visible_characters(get_visible_characters()+1)
	
