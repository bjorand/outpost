shader_type spatial;

uniform sampler2D ice_texture; // Texture de glace
uniform sampler2D snow_texture; // Texture de neige
uniform sampler2D normal_map; // Carte normale

uniform float snow_coverage : hint_range(0.0, 1.0); // Couverture de neige

void fragment() {
    vec4 ice = texture(ice_texture, UV);
    vec4 snow = texture(snow_texture, UV);

    vec4 final_texture = mix(ice, snow, snow_coverage);
    ALBEDO = final_texture.rgb;

    NORMAL = texture(normal_map, UV).rgb * 2.0 - 1.0;
    ROUGHNESS = snow_coverage; // Plus rugueux si couvert de neige
}
