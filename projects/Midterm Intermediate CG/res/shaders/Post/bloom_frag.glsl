#version 420

layout(location = 0) in vec2 inUV;

uniform float u_threshold = 0.0;
uniform float u_strength;

uniform float u_resolution;
uniform float u_radius;
uniform vec2 u_direction = vec2(2.0, 2.0);

uniform sampler2D s_colorTexture;

out vec4 fragColor;
void main()
{
    vec4 color = texture2D( s_colorTexture , inUV);

    // convert rgb to grayscale/brightness
    float brightness = dot( color.rgb , vec3( 0.2126 , 0.7152 , 0.0722 ) );

	float blur = u_radius/u_resolution;
	float hstep = u_direction.x;
	float vstep = u_direction.y;

    vec4 sum = texture2D( s_colorTexture , vec2( inUV.x - 4.0*blur*hstep , inUV.y - 4.0*blur*vstep )) * 0.0162162162;
	sum += texture2D( s_colorTexture , vec2( inUV.x - 3.0*blur*hstep , inUV.y - 3.0*blur*vstep )) * 0.0540540541;
	sum += texture2D( s_colorTexture , vec2( inUV.x - 2.0*blur*hstep , inUV.y - 2.0*blur*vstep )) * 0.1216216216;
	sum += texture2D( s_colorTexture , vec2( inUV.x - 1.0*blur*hstep , inUV.y - 1.0*blur*vstep )) * 0.1945945946;
	sum += texture2D( s_colorTexture , vec2( inUV.x , inUV.y )) * 0.2270270270;
	sum += texture2D( s_colorTexture , vec2( inUV.x + 1.0*blur*hstep , inUV.y + 1.0*blur*vstep )) * 0.1945945946;
	sum += texture2D( s_colorTexture , vec2( inUV.x + 2.0*blur*hstep , inUV.y + 2.0*blur*vstep )) * 0.1216216216;
	sum += texture2D( s_colorTexture , vec2( inUV.x + 3.0*blur*hstep , inUV.y + 3.0*blur*vstep )) * 0.0540540541;
	sum += texture2D( s_colorTexture , vec2( inUV.x + 4.0*blur*hstep , inUV.y + 4.0*blur*vstep )) * 0.0162162162;

    if ( brightness > u_threshold ) 
    {	
        fragColor = vec4( u_strength * color.rgb + sum.rgb, 1.0 );
    }
    else fragColor = vec4( 0.0 , 0.0 , 0.0 , 1.0 );
 }