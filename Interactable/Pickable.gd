extends Interactable

class_name Pickable

@onready var camera = get_node("/root/World/Player/Camera3D")

var pickup_lerp : float = 0.3
var object : Node3D
@export var pickup_distance: Vector3 = Vector3(0,0,-0.4)
var picked_up : bool = false

func add_inventory():
	Inventory.add_item("floppy")
	queue_free()

func take():
	picked_up = true
	#object.freeze = true
	
func drop():
	picked_up = false
	#object.freeze = false
	
func get_interactions():
	pass
	
func _physics_process(delta: float) -> void:
	if picked_up:
		var camera_transform = camera.global_transform
		object.global_transform = object.global_transform.interpolate_with(camera_transform.translated_local(pickup_distance), pickup_lerp)
