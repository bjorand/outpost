extends Interactable

@export var computer: NodePath

@onready var computer_node = get_node(computer)

@onready var fullscreen = false

func get_interaction_text():
	return "Use computer"

func _ready():
	pass
	
func interact():
	fullscreen = !fullscreen
	Global.fullscreen_requested.emit(computer_node.viewport.get_texture())
	
