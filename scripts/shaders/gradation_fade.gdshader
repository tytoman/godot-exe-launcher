shader_type canvas_item;

uniform vec4 color : source_color = vec4(0, 0, 0, 1);
uniform float angle = 0.0;
uniform float offset = 0.0;
uniform float fade_scale = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV;
	vec2 direction = vec2(cos(radians(angle)), sin(radians(angle)));
	float d = direction.x * uv.x + direction.y * uv.y - offset - 0.5 * (sqrt(2.0) + direction.x + direction.y);
	d /= sqrt(2.0) * fade_scale;
	d = clamp(d, -1.0, 0.0);
	COLOR = mix(COLOR, color, -d);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
