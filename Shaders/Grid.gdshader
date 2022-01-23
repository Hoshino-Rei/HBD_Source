shader_type canvas_item;

uniform vec2 size = vec2(10, 20);
uniform float cell_size = 16;
uniform float cell_spacing = 2;
uniform vec4 line_color : hint_color;

uniform sampler2D texture_offset_uv : hint_black;
uniform vec2 texture_offset_scale = vec2(0.2, 0.2);
uniform float texture_offset_height = 0.1;

uniform float texture_offset_time_scale = 0.05;

uniform float sine_time_scale = 0.03;
uniform vec2 sine_offset_scale = vec2(0.4, 0.4);
uniform float sine_wave_size = 0.4;

vec2 calculate_sine_wave(float time, float multiplier, vec2 uv, vec2 offset_scale) {
	float time_multiplied = time * multiplier;
	float unique_offset = uv.x + uv.y;
	return vec2(
		sin(time_multiplied + unique_offset * offset_scale.x),
		cos(time_multiplied + unique_offset * offset_scale.y));
}

varying vec2 v;

void vertex() {
	vec2 base_uv_offset = UV * texture_offset_scale;
	base_uv_offset += TIME * texture_offset_time_scale;

	vec2 adjusted_uv = UV * cell_size;
	adjusted_uv.y *= cell_spacing;
	
	vec2 texture_based_offset = texture(texture_offset_uv, base_uv_offset).rg * 2.0 - 1.0;
	vec2 sine_offset = calculate_sine_wave(TIME, sine_time_scale, adjusted_uv, sine_offset_scale);

	vec2 sine_uv_offset = sine_offset * sine_wave_size;
	vec2 final_waves_uvs = adjusted_uv + texture_based_offset 
			* texture_offset_height + sine_uv_offset;
	
	v = VERTEX + final_waves_uvs;
}

void fragment() {

	COLOR.a = 0.;
	float step_size = cell_size + cell_spacing;
	float ratio = cell_spacing / step_size;
	// Grid
	if (fract(v.x / step_size) < ratio || fract(v.y / step_size) < ratio) COLOR = line_color;
}