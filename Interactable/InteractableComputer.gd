extends Interactable

@export var computer: NodePath

@onready var computer_node = get_node(computer)

@onready var fullscreen = false

func get_interactions():
	return {
		"key": "E",
		"actions": [
			{
				"text": "Use computer",
				"fn": interact,
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

func _ready():
	pass
	
func interact():
	fullscreen = !fullscreen
	Global.fullscreen_requested.emit(computer_node.viewport.get_texture())
	
