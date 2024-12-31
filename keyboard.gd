extends Node3D

@onready var viewport := $SubViewport
@onready var shell := viewport.get_node("Shell/RichTextLabel")
@onready var screen = get_node("screen")

func reset():
	print("Computer reset asked")

var input_buffer: String = ""

const KEY_TO_ASCII = {
	KEY_ESCAPE: 27,        # ASCII for Escape
	KEY_ENTER: 13,         # ASCII for Enter
	KEY_TAB: 9,            # ASCII for Tab
	KEY_BACKSPACE: 8,      # ASCII for Backspace
	KEY_DELETE: 127,       # ASCII for Delete
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var shader_material = $screen.get_active_material(0)
	#get_surface_material(0).set_shader_param("param", value)
	var m = $screen.get_active_material(0)
	m.set_render_priority(0)
	var m2 = ShaderMaterial.new()
	m2.shader = preload("res://screen.gdshader")
	m2.set_shader_parameter("emission_texture", $SubViewport.get_texture())
	m2.set_shader_parameter("emission_strength", 10.0)
	m2.set_render_priority(1)
	m.set_next_pass(m2)

	#shader_material.set_shader_parameter("emission_texture", $screen/SubViewport.get_texture())
	
	#shader_material.set_shader_param("emission_strength", 2.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func send_command():
	shell.socket.put_string(input_buffer)
	input_buffer = ""

func _input(event: InputEvent):
	if event is InputEventKey and event.pressed:
		if event.physical_keycode  == KEY_ENTER:
			var ascii_code = KEY_TO_ASCII[event.physical_keycode]
			input_buffer += char(ascii_code)
			send_command()
		elif event.unicode == KEY_BACKSPACE and input_buffer.length() > 0:
			# Supprimer le dernier caractère pour Backspace
			input_buffer = input_buffer.substr(0, input_buffer.length() - 1)
		elif event.unicode > 0:
			# Ajouter le caractère correspondant à la touche pressée
			input_buffer += char(event.unicode)
			shell.ansi_to_bbcode(char(event.unicode))
			shell.render_screen()
		#elif KEY_TO_ASCII.has(event.physical_keycode):
			#var ascii_code = KEY_TO_ASCII[event.physical_keycode]
			#$SubViewport/RichTextLabel.socket.put_string(char(ascii_code))
		print("> " + input_buffer)  # Affiche le buffer actuel pour débogage
			
		#var ascii_code = 0
		##fullscreen_requested.emit(viewport.get_texture())
		## Check if the key has a printable character
		#if event.unicode > 0:
			#ascii_code = event.unicode
		## Check if the key is in the non-printable ASCII map
		#elif KEY_TO_ASCII.has(event.physical_keycode):
			#ascii_code = KEY_TO_ASCII[event.physical_keycode]
		#
		#if ascii_code > 0:
			#print("ASCII Code:", ascii_code, "Character:", char(ascii_code))
			#$SubViewport/RichTextLabel.socket.put_string(char(ascii_code))
			##$SubViewport/RichTextLabel.socket.put_string("ls\n")
		#else:
			#print("Key not mapped to ASCII:", event.physical_keycode)
