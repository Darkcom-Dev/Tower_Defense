shader_type canvas_item;

uniform vec2 tilded_factor = vec2(2.5, 2.5);
uniform float aspect_ratio = 0.8;
uniform vec2 offset_scale = vec2(0.5, 0.5);


void fragment() {
vec2 tilded_uvs = UV * tilded_factor;
tilded_uvs.y *= aspect_ratio;

vec2 waves_uv_offset;
waves_uv_offset.x = sin(TIME + (tilded_uvs.x + tilded_uvs.y) * offset_scale.x);
waves_uv_offset.y = cos(TIME + (tilded_uvs.x + tilded_uvs.y) * offset_scale.y);

//COLOR = vec4(waves_uv_offset, 0.0, 1.0);
COLOR = texture(TEXTURE, tilded_uvs + waves_uv_offset*0.2);
}
