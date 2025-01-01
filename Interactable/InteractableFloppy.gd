extends Pickable

@export var floppy: NodePath
@export var floppy_label: String

@onready var node = get_node(floppy)

@export  var read_only = false


func get_interactions():
	return {
		"key": "E",
		"actions": [
			{
				"text": "Take" if not picked_up else "Drop",
				"fn": take if not picked_up else drop,
			},
			{
				"text": "Put in inventory",
				"fn": add_inventory,
			},
			{
				"text": "Set read-only" if not read_only else "Disable read-only",
				"fn": ro,
			},
		]
	}


	

func ro():
	read_only = !read_only

func _ready():
	object = node
	pass
	
	
