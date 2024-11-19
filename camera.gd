extends Camera3D

# Variables pour la sensibilité de la souris et la vitesse de déplacement
@export var mouse_sensitivity: Vector2 = Vector2(0.1, 0.1)
@export var move_speed: float = 5.0
@export var sprint_multiplier: float = 2.0

# Variables internes pour gérer la rotation
var rotation_x: float = 0.0
var rotation_y: float = 0.0

func _ready():
	# Capture le curseur pour un contrôle à la souris
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float):
	# Gérer la rotation avec la souris
	handle_mouse_input()

	# Gérer le déplacement avec le clavier
	handle_keyboard_input(delta)

func handle_mouse_input():
	# Récupérer le déplacement de la souris

	# Appliquer la rotation
	rotation_x -=  mouse_sensitivity.y
	rotation_y -=  mouse_sensitivity.x

	# Limiter l'angle vertical pour éviter les retournements
	rotation_x = clamp(rotation_x, -90, 90)

	# Appliquer la rotation à la caméra
	rotation_degrees = Vector3(rotation_x, rotation_y, 0)

func handle_keyboard_input(delta: float):
	# Détecter les touches enfoncées pour le mouvement
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x

	# Sprint
	var speed = move_speed
	if Input.is_action_pressed("sprint"):
		speed *= sprint_multiplier

	# Appliquer le déplacement
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		position += direction * speed * delta

func _input(event):
	# Échappe pour libérer le curseur
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
