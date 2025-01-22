shader_type canvas_item;

uniform float timeScale = 2;
uniform float amplitude = 1.0f;

void vertex() {

	VERTEX.y += sin(TIME * timeScale + VERTEX.y + VERTEX.x) * amplitude;
}