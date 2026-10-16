shader_type spatial;

uniform vec3 clip_point = vec3(0,0,0);
uniform vec3 clip_normal = vec3(0,1,0);

varying vec3 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1)).xyz;
}

void fragment() {
	float side = dot(
		world_pos - clip_point,
		clip_normal
	);
	
	if (side < 0.0) {
		discard;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
