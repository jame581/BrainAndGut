shader_type canvas_item;

uniform float size : hint_range(25.0, 200.0) = 200.0;
uniform vec4 color_white : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 color_enabled : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 color_disabled : source_color = vec4(0.0, 0.0, 0.0, 1.0);

uniform float speed : hint_range(0.0, 10.0) = 1.0;

global uniform bool first_puzzle_solved;
global uniform bool second_puzzle_solved;

uniform bool first_puzzle_lock = false;
uniform bool second_puzzle_lock = false;

uniform float direction_x : hint_range(-1.0, 1.0) = 1.0; // Horizontal movement
uniform float direction_y : hint_range(-1.0, 1.0) = 1.0; // Vertical movement


void fragment() {

	// Whether lock is released - works for both side of door
	float door_enabled = float(first_puzzle_lock) * float(first_puzzle_solved) + float(second_puzzle_solved) * float(second_puzzle_lock);

    vec2 pos = FRAGCOORD.xy / size;

    float time_offset = TIME * speed;

	vec2 direction = normalize(vec2(direction_x, direction_y));

	vec2 offset = direction * time_offset;

	pos = floor(pos + offset);

	float x_pattern = mod(pos.x, 2) * direction_x;
	float y_pattern = mod(pos.y, 2) * direction_y;

	float pattern_mask = mod(x_pattern + y_pattern, 2);

	vec4 texture_color = texture(TEXTURE, UV);
	float mask_value = texture(TEXTURE, UV).r * texture(TEXTURE, UV).a;

	// Selects enabled or disabled color based on the door state
	vec4 door_color = mix(color_disabled, color_enabled, door_enabled);

	// Combine white and red based on the pattern mask - value between 0 and 1
	vec4 pattern = mix(color_white, door_color, pattern_mask);

	//COLOR = mix(texture_color, pattern, mask_value);
	COLOR = mix(texture_color, pattern, mask_value);
}
