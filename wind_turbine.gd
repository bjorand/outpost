extends MeshInstance3D

@export var speed : Vector3 = Vector3(50,0,0)
var r = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation_degrees += speed * delta
