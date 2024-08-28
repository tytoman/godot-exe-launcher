shader_type canvas_item;

uniform float blur: hint_range(0.0, 5.0) = 0.0;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, repeat_disable, filter_linear_mipmap;

void fragment() {
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV, blur * COLOR.a);
}
