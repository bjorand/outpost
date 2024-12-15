extends DirectionalLight3D

@export var day_length: float = 10.0  # Durée du cycle en secondes
@export var night_light_energy: float = 0.1  # Intensité lumineuse minimale la nuit
@export var day_light_energy: float = 2.0  # Intensité lumineuse maximale le jour
@export var sun_color_day: Color = Color.PAPAYA_WHIP  # Couleur du soleil le jour
@export var sun_color_night: Color = Color(0.1, 0.1, 0.3)  # Couleur du soleil la nuit
@export var procedural_sky: ProceduralSkyMaterial  # Référence au ProceduralSky
var sun_angle: float = 0.0  # Angle actuel du soleil (0-360°)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var angle_increment = 360.0 / day_length * delta
	sun_angle = int(sun_angle + angle_increment) % 360
	$".".rotation_degrees.x +=  angle_increment
	var normalized_time = (cos(sun_angle_to_radians()) + 1.0) / 2.0
	#$".".light_energy = lerp(night_light_energy, day_light_energy, normalized_time)
	# Ajuster la couleur de la lumière (jour vs nuit)
	#$".".light_color = sun_color_day.lerp(sun_color_night, 1.0 - normalized_time)
	
	# Ajuster les couleurs du ciel en fonction de l'heure
	#$"../WorldEnvironment".environment.energy_multiplier = lerp(0.1, 2.0, normalized_time)
	#procedural_sky.sky_horizon_color = sun_color_day.lerp(sun_color_night, 1.0 - normalized_time)

func sun_angle_to_radians() -> float:
	return deg_to_rad(sun_angle - 90.0)  # Décale l'angle pour que le cycle commence à l'aube
