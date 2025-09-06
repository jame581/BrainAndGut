shader_type canvas_item;

uniform float size : hint_range(25.0, 200.0) = 200.0;
uniform vec4 color_white : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 color_enabled : source_color = vec4(0.129412, 0.631373, 0.47451, 1.0);  // Greenish (matches scene)
uniform vec4 color_disabled : source_color = vec4(0.843137, 0.14902, 0.219608, 1.0); // Reddish (matches scene)

uniform float speed : hint_range(0.0, 10.0) = 1.0;

global uniform float first_puzzle_solved = 0.0;
global uniform float second_puzzle_solved = 0.0;

uniform bool first_puzzle_lock = false;
uniform bool second_puzzle_lock = false;

uniform float direction_x : hint_range(-1.0, 1.0) = 1.0; // Horizontal movement
uniform float direction_y : hint_range(-1.0, 1.0) = 1.0; // Vertical movement


void fragment() {

	// Whether lock is released - works for both side of door
	// Convert global bools to float for arithmetic
	float door_enabled = float(first_puzzle_lock) * float(first_puzzle_solved) + float(second_puzzle_solved) * float(second_puzzle_lock);

	door_enabled = step(0.5, door_enabled); // Ensure it's 0 or 1

    vec2 pos = FRAGCOORD.xy / size;

    float time_offset = TIME * speed;

	vec2 direction = vec2(direction_x, direction_y);
	// Avoid division by zero and precision issues
	if (length(direction) < 0.001) {
		direction = vec2(1.0, 0.0);
	}
	direction = normalize(direction);

	vec2 offset = direction * time_offset;

	pos = floor(pos + offset);

	// Simplified pattern calculation for better web compatibility
	float x_pattern = mod(pos.x, 2.0);
	float y_pattern = mod(pos.y, 2.0);

	// Create checkerboard pattern based on direction
	float pattern_mask;
	if (abs(direction_x) > abs(direction_y)) {
		// Horizontal stripes
		pattern_mask = x_pattern;
	} else {
		// Vertical stripes
		pattern_mask = y_pattern;
	}

	// Ensure clean 0 or 1 values
	pattern_mask = step(0.5, pattern_mask);

	vec4 texture_color = texture(TEXTURE, UV);
	// Use alpha channel as mask, with fallback to red channel if alpha is 0
	float alpha_mask = texture_color.a;
	float red_mask = texture_color.r;
	float mask_value = max(alpha_mask, red_mask);

	// Selects enabled or disabled color based on the door state
	vec4 door_color = mix(color_disabled, color_enabled, door_enabled);

	// Combine white and red based on the pattern mask - value between 0 and 1
	vec4 pattern = mix(color_white, door_color, pattern_mask);

	float visible_mask = texture(TEXTURE, UV).r * texture(TEXTURE, UV).a;

	// Ensure we always have some visibility
	COLOR = mix(texture_color, pattern, visible_mask);
}
