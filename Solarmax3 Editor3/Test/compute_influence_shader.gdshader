shader_type canvas_item;

uniform int node_number;
uniform vec2 node_positions[4];
uniform int node_camps[4];
uniform float node_radii[4];

uniform float adhesion = 1;

void vertex() {
	// Called for every vertex the material is visible on.
}
// 暂时用不到node_camp
void fragment() {
	vec2 screen_pos = UV / SCREEN_PIXEL_SIZE;
	
	float total_influence = 0.0;
	
	for (int i = 0; i < node_number; i++){
		vec2 node_position = node_positions[i];
		int node_camp = node_camps[i];
		float node_radius = node_radii[i];
		
		float r = distance(screen_pos, node_position);
		float influence = (r <= node_radius) ? 1.0 : 1.0 / (r - node_radius);
		
		total_influence += influence;
	}
	
	COLOR = vec4(total_influence, 0, 0, 1);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
