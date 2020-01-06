shader_type canvas_item;

// Shader color
uniform vec3 color = vec3(1.0,1.0,1.0);
uniform int octives = 4;

float rand(vec2 coord) {
	return fract(sin(dot(coord, vec2(56, 78))*100.0)*100.0);
}

float noise(vec2 coord) {
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	
	float a = rand(i);
	float b = rand(i + vec2(1.0,0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));
	
	// cubic interpolation.
	vec2 cubic = f * f * (3.0 -2.0) * f;
	return  mix(a, b, cubic.x) + (c-a) * cubic.y * (1.0 -cubic.x) + (d-b) * cubic.x * cubic.y;
}

uniform float scale_value = 0.4;
uniform float coordinate_movement = 3.0;

// Fractal brownean motion
float fbm(vec2 coord) {
	float value = 0.0;
	float scale = scale_value;
	
	for(int i = 0; i<octives; i++) {
		value += noise(coord) * scale;
		coord *= coordinate_movement;
		scale *= scale_value;
	}
	
	return value;
}

void fragment() {
	vec2 coord = UV * 20.0;
	
	vec2 motion = vec2(fbm(coord + vec2(TIME * 0.2, TIME * -0.09)));
	float final = fbm(coord + motion);
	
	COLOR = vec4(color, final);
}