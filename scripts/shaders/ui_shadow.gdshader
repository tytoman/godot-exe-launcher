// version: 1.1
// repository: https://github.com/TABmk/godot-2d-shadow-shader

shader_type canvas_item;

uniform vec2 offset = vec2(-10.0, -10.0);
uniform vec4 color : source_color;

vec4 hideExtra(vec2 uv, sampler2D txtr, bool isMain) {
	if (uv.x >= 0.0 && uv.x <= 1.0 && uv.y >= 0.0 && uv.y <= 1.0) {
		vec4 texColor = texture(txtr, uv);
		return isMain ? texColor : vec4(color.rgb, texColor.a - (1.0 - color.a));
	}
	return vec4(0.0);
}

void fragment() {
	// size of a single pixel
	vec2 singlePX = TEXTURE_PIXEL_SIZE;

	// main downscaled and centered element
	vec2 uv = UV;
	vec4 uv_texture = hideExtra(uv, TEXTURE, true);


	// same element, but with offset
	vec2 shadow_uv = uv + offset * singlePX;
	vec4 shadow = hideExtra(shadow_uv, TEXTURE, false);

	// show main element on top of shadow
	vec4 res = mix(shadow, uv_texture, uv_texture.a);
	COLOR = res;
}
