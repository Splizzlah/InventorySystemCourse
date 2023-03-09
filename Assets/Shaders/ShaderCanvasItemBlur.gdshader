shader_type canvas_item;

uniform float blur_amount: hint_range(0.0, 5.0);

void fragment() {
	COLOR.rgb = textureLod("uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;", SCREEN_UV, blur_amount).rgb;
}