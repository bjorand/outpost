extends Node3D

@onready var fullscreen_node := $CanvasLayer/TextureRect
@onready var computer = $Computer
@onready var viewport = get_node("Computer/SubViewport")
@onready var shell = viewport.get_node("Shell/RichTextLabel")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.fullscreen_requested.connect(_on_computer_fullscreen_requested)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_computer_fullscreen_requested(viewport_texture: Texture):
	# Active le mode plein écran avec le contenu de l'ordinateur
	fullscreen_node.texture = viewport_texture
	fullscreen_node.visible = true
	var s = get_window().size
	viewport.size = s
	#$Computer/SubViewport/RichTextLabel.autowrap_mode = TextServer.AUTOWRAP_WORD
	#shell.add_theme_font_size_override("normal_font_size", 20)
	#shell.add_theme_font_size_override("bold_font_size", 20)
	
	#var ff = f.duplicate()
	#ff.
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
#func _input(event: InputEvent):
	#if event is InputEventKey and event.pressed and event.physical_keycode == KEY_E: 
		
	
func _unhandled_input(event):
	# Quitte le mode plein écran avec ESC
	if fullscreen_node.visible:
		$Computer/SubViewport.push_input(event)
	if fullscreen_node.visible and event is InputEventKey and event.pressed and event.physical_keycode == KEY_ESCAPE:
		deactivate_fullscreen()

func deactivate_fullscreen():
	fullscreen_node.visible = false
	viewport.size = Vector2(512.0, 512.0)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
