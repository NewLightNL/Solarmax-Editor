shader_type canvas_item;

uniform sampler2D render_texture;
uniform float threshold = 0.8;
uniform vec4 influence_color : source_color = vec4(0, 0, 1, 1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 base_color = texture(TEXTURE, UV);
	vec4 influence_value = texture(render_texture, UV);
	
	if (influence_value.r > threshold){
		COLOR = mix(base_color, influence_color, 0.7);
	} else {
		COLOR = base_color;
	}
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
