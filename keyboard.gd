extends Node3D

signal fullscreen_requested(viewport_texture: Texture)

@onready var viewport := $SubViewport
@onready var rich_text_label := viewport.get_node("RichTextLabel")

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
	m2.set_shader_parameter("emission_strength", 20.0)
	m2.set_render_priority(1)
	m.set_next_pass(m2)

	#shader_material.set_shader_parameter("emission_texture", $screen/SubViewport.get_texture())
	
	#shader_material.set_shader_param("emission_strength", 2.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event: InputEvent):
	if event is InputEventKey and event.pressed:
		var ascii_code = 0
		#fullscreen_requested.emit(viewport.get_texture())
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
