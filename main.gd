extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Global.fullscreen_requested.connect(_on_computer_fullscreen_requested)
	Network.connect_to_server()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
