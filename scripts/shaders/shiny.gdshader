shader_type canvas_item;

render_mode blend_add;

uniform vec4 color : source_color = vec4(0, 0, 0, 1);
uniform float angle = 0.0;
uniform float min_edge = 0.8;
uniform float max_edge = 0.9;
uniform float offset = 0.0;

void fragment() {
	vec2 uv = UV;
	vec2 direction = vec2(cos(radians(angle)), sin(radians(angle)));
	float d = abs(direction.x * uv.x + direction.y * uv.y + offset - 0.5 * (sqrt(2.0) + direction.x + direction.y));
	d /= sqrt(2.0);
	d = 1.0 - d;
	COLOR.a *= smoothstep(min_edge, max_edge, d);
}