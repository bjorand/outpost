extends Node3D

@onready var fullscreen_node := $CanvasLayer/TextureRect
@onready var computer = $Computer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	computer.fullscreen_requested.connect(_on_computer_fullscreen_requested)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_computer_fullscreen_requested(viewport_texture: Texture):
	# Active le mode plein écran avec le contenu de l'ordinateur
	fullscreen_node.texture = viewport_texture
	fullscreen_node.visible = true
	var s = get_window().size
	$Computer/SubViewport.size = s
	$Computer/SubViewport/RichTextLabel.autowrap_mode = TextServer.AUTOWRAP_WORD
	$Computer/SubViewport/RichTextLabel.add_theme_font_size_override("normal_font_size", 40)
	
	#var ff = f.duplicate()
	#ff.
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
#func _input(event: InputEvent):
	#if event is InputEventKey and event.pressed and event.physical_keycode == KEY_E: 
		
	
func _unhandled_input(event):
	# Quitte le mode plein écran avec ESC

	if fullscreen_node.visible and event is InputEventKey and event.pressed and event.physical_keycode == KEY_ESCAPE:
		deactivate_fullscreen()

func deactivate_fullscreen():
	fullscreen_node.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
