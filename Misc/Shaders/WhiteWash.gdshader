shader_type canvas_item;
void fragment(){
	vec4 m = COLOR / texture(TEXTURE, UV); // modulate
	COLOR = m;
}