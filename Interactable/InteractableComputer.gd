extends Interactable

@export var computer: NodePath

@onready var computer_node = get_node(computer)

func get_interaction_text():
	return "Use computer"

func _ready():
	pass
	
func interact():
	pass
	
