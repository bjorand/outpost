extends RayCast3D

var current_collider
var action_index = 0
var config = {}

@onready var first_interaction_label = get_node("/root/World/UI/InteractionPanelContainer/InteractionLabel")
@onready var key_interaction_label = get_node("/root/World/UI/InteractionPanelContainer/InteractionLabel/KeyPanelContainer/KeyLabel")
@onready var more_interaction_label = get_node("/root/World/UI/MorePanelContainer/MoreInteractionsLabel")
@onready var more_panel = get_node("/root/World/UI/MorePanelContainer")
@onready var interaction_panel = get_node("/root/World/UI/InteractionPanelContainer")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_interactions()

func _unhandled_input(event: InputEvent) -> void:
	if current_collider == null:
		return
	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom in
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if action_index > 0:
					action_index -= 1
					set_interactions()
				# call the zoom function
			# zoom out
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if action_index < (config.actions.size()-1):
					action_index += 1
					set_interactions()
				# call the zoom function

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var collider = get_collider()

	if is_colliding() and collider is Interactable:
		if current_collider != collider:
			action_index = 0
			$"../../../UI/CenterContainer".focused()
			config = collider.get_interactions()
			set_interactions()
			current_collider = collider
			
		if Input.is_action_just_pressed("Interact"):
			# collider.interact()
			config.actions[action_index].fn.call()
			config = collider.get_interactions()
			set_interactions()
	elif current_collider:
		$"../../../UI/CenterContainer".unfocused()
		current_collider = null
		config = {}
		set_interactions()
		
func set_interactions():
	if config == {}:
		#first_interaction_label.set_text("")
		interaction_panel.set_visible(false)
		
		more_panel.set_visible(false)
	else:
		interaction_panel.set_visible(true)
		key_interaction_label.set_text(config.key)
		first_interaction_label.set_text(config.actions[action_index].text)
		#first_interaction_label.set_visible(true)
		
		var more = ""
		for action_id in config.actions.size():
			var action = config.actions[action_id]
			if action_index == action_id:
				continue
			more += action.text + "\n"
		more_interaction_label.set_text(more)
		if config.actions.size() > 1:
			more_panel.set_visible(true)
			
