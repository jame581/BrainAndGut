shader_type canvas_item;

uniform vec4 color_white : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 color_enabled : source_color = vec4(0.129412, 0.631373, 0.47451, 1.0);  // Greenish (matches scene)
uniform vec4 color_disabled : source_color = vec4(0.843137, 0.14902, 0.219608, 1.0); // Reddish (matches scene)

uniform float period : hint_range(0.1, 10.0) = 1;

global uniform float second_puzzle_solved = 0.0;

void fragment() {

	float solved = second_puzzle_solved;

	float door_enabled = step(0.5, solved);

	float visible_mask = texture(TEXTURE, UV).r * texture(TEXTURE, UV).a;

	vec4 texture_color = texture(TEXTURE, UV);

	vec4 final_color;

	if (door_enabled > 0.5) {
		final_color = color_enabled;
	} else {
		float pulse = sin(TIME * 2.0 * PI / period) * 0.5 + 0.5;
		final_color = mix(color_disabled, color_white, pulse);
	}

	COLOR = mix(texture_color, final_color, visible_mask);
}
