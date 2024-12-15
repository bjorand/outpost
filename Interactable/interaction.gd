extends RayCast3D

var current_collider

@onready var interaction_label = get_node("/root/World/UI/InteractionLabel")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_interaction_text("")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var collider = get_collider()

	if is_colliding() and collider is Interactable:
		if current_collider != collider:
			$"../../../UI/CenterContainer".focused()
			set_interaction_text(collider.get_interaction_text())
			current_collider = collider
			
		if Input.is_action_just_pressed("Interact"):
			collider.interact()
			set_interaction_text(collider.get_interaction_text())
	elif current_collider:
		$"../../../UI/CenterContainer".unfocused()
		current_collider = null
		set_interaction_text("")
		
func set_interaction_text(text):
	if !text:
		interaction_label.set_text("")
		interaction_label.set_visible(false)
	else:
		var interact_key = "e"
		interaction_label.set_text("Press %s to %s" % [interact_key, text])
		interaction_label.set_visible(true)
