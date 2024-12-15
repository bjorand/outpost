extends CenterContainer

var r : float = 10.0
var target_r : float = 10.0
@export var size_speed: float = 5.0  # Vitesse de l'interpolation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	r = lerp(r, target_r, size_speed * delta)
	queue_redraw()

func focused():
	target_r = 30.0
	
func unfocused():
	target_r = 10.0

func _draw():
	#draw_circle(Vector2(0,0), 10.0, Color.WHITE)
	draw_arc(Vector2(0,0), r, 0, 360, 40, Color(191, 255, 0, 0.5) , r/3)
