shader_type spatial;
uniform sampler2D ice_texture; 
uniform sampler2D height_map; 
uniform float height_scale = 10.0;

uniform float metallic : hint_range(0.0, 1.0) = 0.0;
uniform float roughness : hint_range(0.0, 1.0) = 0.8;
uniform float transparency : hint_range(0.0, 1.0) = 0.2;
uniform vec3 tint_color : source_color = vec3(0.6, 0.8, 1.0);
uniform sampler2D noise_texture;
uniform vec2 uv_scale = vec2(10.0, 10.0);

vec3 calc_normal(vec2 uv) { 
    const vec3 off = vec3(-1,0,1);
    vec2 texelSize = 1.0 / vec2(textureSize(height_map, 0));

    float left = texture(height_map, uv + texelSize * off.xy).x;
    float right = texture(height_map, uv + texelSize * off.zy).x;
    float top = texture(height_map, uv + texelSize * off.yx).x;
    float down = texture(height_map, uv + texelSize * off.yz).x;

    return normalize(vec3(left-right, 2.0, down-top));
}

void fragment() {
	vec2 scaled_uv = UV * uv_scale;
	vec3 ice_albedo = texture(ice_texture, scaled_uv).rgb;
	//ALBEDO = ice_albedo;
	//ALBEDO = mix(ice_albedo, tint_color, 0.5);
	ROUGHNESS = roughness;
    METALLIC = metallic;
	ALPHA = 1.0 - transparency;
	//
	float depth_effect = texture(noise_texture, scaled_uv).r * transparency;
    ALBEDO = mix(ALBEDO, tint_color, depth_effect);
    ALPHA = 1.0 - (transparency + depth_effect * 0.5);
}

void vertex() { 
	vec2 scaled_uv = UV * uv_scale;
    VERTEX.y += texture(height_map, UV).x * height_scale; 
    NORMAL = calc_normal(scaled_uv); 
}