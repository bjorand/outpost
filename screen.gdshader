shader_type spatial;

uniform sampler2D emission_texture : source_color;
uniform float emission_strength : hint_range(0.0, 5.0);

void fragment() {
	vec4 tex_color = texture(emission_texture, UV);
	EMISSION = tex_color.rgb * emission_strength;  // Applique l'émission
}
