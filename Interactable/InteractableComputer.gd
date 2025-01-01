extends Interactable

@export var computer: NodePath

@onready var computer_node = get_node(computer)
@onready var fullscreen_node = computer_node.get_node("CanvasLayer/TextureRect")
@onready var viewport = computer_node.get_node("SubViewport")

@onready var fullscreen = false

func get_interactions():
	var actions = {
		"key": "E",
		"actions": [
			{
				"text": "Use computer",
				"fn": enable_fullscreen,
			},
			{
				"text": "Reset computer",
				"fn": computer_node.reset,
			},
			{
				"text": "Shutdown computer",
				"fn": computer_node.shutdown,
			}
		]
	}
	
	return actions

func _ready():
	pass
	
	
func enable_fullscreen():
	fullscreen = !fullscreen
	#Global.fullscreen_requested.emit(computer_node.viewport.get_texture())
	fullscreen_node.texture = viewport.get_texture()
	fullscreen_node.visible = true
	var s = get_window().size
	viewport.size = s
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event):
	# Quitte le mode plein écran avec ESC
	if fullscreen_node.visible:
		viewport.push_input(event)
	if fullscreen_node.visible and event is InputEventKey and event.pressed and event.physical_keycode == KEY_ESCAPE:
		deactivate_fullscreen()

func deactivate_fullscreen():
	fullscreen_node.visible = false
	viewport.size = Vector2(512.0, 512.0)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
