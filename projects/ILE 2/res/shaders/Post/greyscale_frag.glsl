#version 420

layout(location = 0) in vec2 inUV;

out vec4 frag_color;

layout (binding = 0) uniform sampler2D s_screenTex;

//Affects how greyscale
//lower the number, closer we are to regular
uniform float u_intensity = 1.0;

void main() 
{
	vec4 source = texture(s_screenTex, inUV);

	float luminence = 0.2989 * source.r + 0.587 * source.g + 0.114 * source.b;

	frag_color.rgb = mix(source.rgb, vec3(luminence), u_intensity);
    frag_color.a = source.a;
}