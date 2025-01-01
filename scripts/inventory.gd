extends Node

var items: Array = []

var visible: bool = false

@onready var item0 = get_node("/root/World/Inventory/MarginContainer/PanelContainer/BoxContainer/GridContainer/Item0")
@onready var inventory_node = get_node("/root/World/Inventory")

func _ready():
	item0.set_visible(false)
	inventory_node.set_visible(visible)


func add_item(item: String) -> void:
	items.append(item)
	print("Added item:", item)
	var item_node = item0.duplicate()
	item_node.set_visible(true)
	item0.get_parent().add_child(item_node)
func show():
	visible = !visible
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		
		
	inventory_node.set_visible(visible)
