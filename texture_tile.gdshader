shader_type canvas_item;

void fragment() { vec2 pos = UV; pos.x = pos.x + TIME * -0.10; COLOR = texture(TEXTURE, pos); }


//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
