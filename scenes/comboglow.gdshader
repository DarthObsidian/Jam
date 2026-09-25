shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0);
uniform float glow_size = 3.0;
uniform float glow_strength = 1.0;

void fragment() {
    vec2 offset = TEXTURE_PIXEL_SIZE * glow_size;

    float alpha = 0.0;

    alpha += texture(TEXTURE, UV + vec2(-offset.x, 0.0)).a;
    alpha += texture(TEXTURE, UV + vec2(offset.x, 0.0)).a;
    alpha += texture(TEXTURE, UV + vec2(0.0, -offset.y)).a;
    alpha += texture(TEXTURE, UV + vec2(0.0, offset.y)).a;

    alpha += texture(TEXTURE, UV + vec2(-offset.x, -offset.y)).a;
    alpha += texture(TEXTURE, UV + vec2(offset.x, -offset.y)).a;
    alpha += texture(TEXTURE, UV + vec2(-offset.x, offset.y)).a;
    alpha += texture(TEXTURE, UV + vec2(offset.x, offset.y)).a;

    alpha /= 8.0;

    COLOR = vec4(glow_color.rgb, alpha * glow_strength);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
