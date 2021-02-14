#version 420

layout(location = 0) in vec2 inUV;

uniform sampler2D colorTexture;

uniform float u_resolution;
uniform float u_radius;
uniform vec2 u_direction = vec2(2.0, 2.0);

out vec4 fragColor;
void main()
{
	float blur = u_radius/u_resolution;
	float hstep = u_direction.x;
	float vstep = u_direction.y;

	vec4 sum = texture2D( colorTexture , vec2( inUV.x - 4.0*blur*hstep , inUV.y - 4.0*blur*vstep )) * 0.0162162162;
	sum += texture2D( colorTexture , vec2( inUV.x - 3.0*blur*hstep , inUV.y - 3.0*blur*vstep )) * 0.0540540541;
	sum += texture2D( colorTexture , vec2( inUV.x - 2.0*blur*hstep , inUV.y - 2.0*blur*vstep )) * 0.1216216216;
	sum += texture2D( colorTexture , vec2( inUV.x - 1.0*blur*hstep , inUV.y - 1.0*blur*vstep )) * 0.1945945946;
	sum += texture2D( colorTexture , vec2( inUV.x , inUV.y )) * 0.2270270270;
	sum += texture2D( colorTexture , vec2( inUV.x + 1.0*blur*hstep , inUV.y + 1.0*blur*vstep )) * 0.1945945946;
	sum += texture2D( colorTexture , vec2( inUV.x + 2.0*blur*hstep , inUV.y + 2.0*blur*vstep )) * 0.1216216216;
	sum += texture2D( colorTexture , vec2( inUV.x + 3.0*blur*hstep , inUV.y + 3.0*blur*vstep )) * 0.0540540541;
	sum += texture2D( colorTexture , vec2( inUV.x + 4.0*blur*hstep , inUV.y + 4.0*blur*vstep )) * 0.0162162162;

	fragColor = vec4( sum.rgb , 1.0 );
}

/*
	// the uniforms for the two gaussian blur passes
	glUniform1f( u_resolution , width );
	glUniform2f( u_direction , 1.0f , 0.0f );
	// draw horizontal
	glUniform1f( u_resolution , height );
	glUniform2f( u_direction , 0.0f , 1.0f );
	// draw vertical
*/