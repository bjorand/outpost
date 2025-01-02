extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var lines = [
		"FPS %d" % Engine.get_frames_per_second(),
		str(Inventory.items.size()),
		Network.get_status_string(),
	]
	
	set_text("\n".join(lines))
