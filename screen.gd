extends MeshInstance3D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


@export var animation_speed: float = 1.0
var time := 0.0

func _process(delta: float):
	time += delta * animation_speed
	# Met à jour les paramètres du shader
