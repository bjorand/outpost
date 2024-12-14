extends MeshInstance3D

func _ready():
	# Créer un matériau émissif
	var material = StandardMaterial3D.new()
	material.emission_enabled = true
	material.emission = Color(1.0, 0.0, 0.0) # Rouge
	material.emission_energy = 4.0
	mesh.material = material

	# Ajouter une lumière proche
	var light = OmniLight3D.new()
	light.light_color = Color(1.0, 0.0, 0.0) # Rouge
	#light.light_ = 10.0
	light.light_energy = 1.0
	add_child(light)
	

	
