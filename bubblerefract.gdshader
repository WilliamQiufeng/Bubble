
shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;
uniform float refractionMagnitude = 30.0;

void fragment() {

	// Possibly a more accurate way to do refraction? Uncomment and see how you like it (and comment out below refraction)
	//vec3 refraction = -refract(vec3(0,0,-1), texture(NORMAL_TEXTURE, UV).rgb, 1.1) *2.0;
	
	vec3 refraction = - texture(NORMAL_TEXTURE, UV).rgb * vec3(1.0,-1.0,1.0);
	
	vec4 textureRead = texture(TEXTURE, UV);
	vec4 offsetScreenRead = texture(SCREEN_TEXTURE, SCREEN_UV + refraction.rg/refractionMagnitude);

	if (textureRead.a  > .01) {
		COLOR = offsetScreenRead;
		//COLOR.a = min(COLOR.a,0.7);
	}
	else {
		COLOR = textureRead;
	}
}

uniform float timeScale = 2;
uniform float amplitude = 1.0f;

void vertex() {

	VERTEX.y += sin(TIME * timeScale + VERTEX.y + VERTEX.x) * amplitude;
}