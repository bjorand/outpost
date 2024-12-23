extends OmniLight3D

@export_range( 0, 1, 0.001 ) var on_duration : float = 0.01:
	set( value ) :
		on_duration = value
		
@export_range( 0, 1, 0.001 ) var off_duration : float = 0.1:
	set( value ) :
		off_duration = value
	
@export var enabled : bool = false:
	set( value ) :
		enabled = value
		

enum STATE {OFF, ON}
var state: int = 0		
var t : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t += delta
	if state == STATE.OFF and t >= off_duration:
		state = STATE.ON
		t = 0.0
		set_visible(true)
	elif state == STATE.ON and t >= on_duration:
		state = STATE.OFF
		t = 0.0
		set_visible(false)
		# Update visuals here
