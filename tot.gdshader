shader_type canvas_item;

uniform float time : hint_range(0, 10);

void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE.xy;
    
    // Scanlines
    float scanline = sin(uv.y * 150.0 + time * 5.0) * 0.1;
    
    // Glitch effect
    float glitch = step(0.95, fract(uv.y + time * 0.1));
    glitch *= step(0.5, fract(uv.x * 10.0 + time * 2.0));
    
    vec3 color = vec3(uv.x, 0.5 + scanline, glitch);
    COLOR = vec4(color, 1.0);
}
