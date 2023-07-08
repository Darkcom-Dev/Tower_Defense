shader_type canvas_item;

uniform sampler2D texture1;
uniform sampler2D colortexture;
uniform vec2 scroll= vec2(0.1, 0.1);
uniform vec2 scroll1 = vec2(0.2,0.2);


void fragment() {
	float textureColor = texture(TEXTURE, UV+ scroll*TIME*2.5).r;
	float textureColor1 = texture(texture1, UV + scroll1*TIME*2.5).r;
	float energy = textureColor + textureColor1- (1.0 -UV.y);
	vec4 color = texture(colortexture, vec2(energy));
	
	COLOR = color;
	
}
