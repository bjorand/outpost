extends MeshInstance3D

const KEY_TO_ASCII = {
	KEY_ESCAPE: 27,        # ASCII for Escape
	KEY_ENTER: 13,         # ASCII for Enter
	KEY_TAB: 9,            # ASCII for Tab
	KEY_BACKSPACE: 8,      # ASCII for Backspace
	KEY_DELETE: 127,       # ASCII for Delete
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event: InputEvent):
	if event is InputEventKey and event.pressed:
		var ascii_code = 0

		# Check if the key has a printable character
		if event.unicode > 0:
			ascii_code = event.unicode
		# Check if the key is in the non-printable ASCII map
		elif KEY_TO_ASCII.has(event.physical_keycode):
			ascii_code = KEY_TO_ASCII[event.physical_keycode]

		if ascii_code > 0:
			print("ASCII Code:", ascii_code, "Character:", char(ascii_code))
			#$"../SubViewport/TextEdit".socket.send_text(string(ascii_code))
		else:
			print("Key not mapped to ASCII:", event.physical_keycode)



