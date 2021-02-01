#version 410

layout(location = 0) in vec3 inPos;
layout(location = 1) in vec3 inColor;
layout(location = 2) in vec3 inNormal;
layout(location = 3) in vec2 inUV;

uniform sampler2D s_Diffuse;
uniform sampler2D s_Diffuse2;
uniform sampler2D s_Specular;

uniform vec3  u_AmbientCol;
uniform float u_AmbientStrength;

uniform vec3  u_LightPos;
uniform vec3  u_LightCol;
uniform float u_AmbientLightStrength;
uniform float u_SpecularLightStrength;
uniform float u_Shininess;

uniform bool u_ambientToggle;
uniform bool u_specularToggle; 
uniform bool u_off; 
uniform bool u_ambientspecular; 
uniform bool u_allcustom; 

const int bands = 5;
const float scaleFactor = 1.0/bands;
const float lightIntensity = 10.0;
uniform vec3 u_eye_pos;

// NEW in week 7, see https://learnopengl.com/Lighting/Light-casters for a good reference on how this all works, or
// https://developer.valvesoftware.com/wiki/Constant-Linear-Quadratic_Falloff
uniform float u_LightAttenuationConstant;
uniform float u_LightAttenuationLinear;
uniform float u_LightAttenuationQuadratic;

uniform float u_TextureMix;

uniform vec3  u_CamPos;

out vec4 frag_color;

// https://learnopengl.com/Advanced-Lighting/Advanced-Lighting
void main() {
	vec3 ambient = u_AmbientLightStrength * u_LightCol;

	// Diffuse
	vec3 N = normalize(inNormal);
	vec3 V = normalize(u_eye_pos - inNormal);
	vec3 lightDir = normalize(u_LightPos - inPos);

	float dif = max(dot(N, lightDir), 0.0);
	vec3 diffuse = dif * u_LightCol;// add diffuse intensity

	//Attenuation
	float dist = length(u_LightPos - inPos);
	float attenuation = 1.0f / (
		u_LightAttenuationConstant + 
		u_LightAttenuationLinear * dist +
		u_LightAttenuationQuadratic * dist * dist);

	// Specular
	vec3 viewDir  = normalize(u_CamPos - inPos);
	vec3 h        = normalize(lightDir + viewDir);

	// Get the specular power from the specular map
	float texSpec = texture(s_Specular, inUV).x;
	float spec = pow(max(dot(N, h), 0.0), u_Shininess); // Shininess coefficient (can be a uniform)
	vec3 specular = u_SpecularLightStrength * texSpec * spec * u_LightCol; // Can also use a specular color

	// Get the albedo from the diffuse / albedo map
	vec4 textureColor1 = texture(s_Diffuse, inUV);
	vec4 textureColor2 = texture(s_Diffuse2, inUV);
	vec4 textureColor = mix(textureColor1, textureColor2, u_TextureMix);

	//ToonShading setup
	vec3 diffuseOut = (diffuse * inColor) / (dist*dist);
	diffuseOut = diffuseOut*lightIntensity;
	diffuseOut = floor(diffuseOut * bands) * scaleFactor;
	float edge = (dot(V, inNormal) < 0.4) ? 0.0 : 1.0;

	vec3 result;
	//toggle if statements
	//ambient only
	if (u_ambientToggle);
	{
		result = ((u_AmbientCol * u_AmbientStrength) + (ambient) * attenuation) * inColor * textureColor.rgb;
	}
	//specular only
	if (u_specularToggle);
	{
		result = ((specular) * attenuation) * inColor * textureColor.rgb;
	}
	//no lighting
	if (u_off)
	{
		result = inColor * textureColor.rgb;	
	}
	//ambient and specular
	if (u_ambientspecular)
	{
		result = ((u_AmbientCol * u_AmbientStrength) + // global ambient light
		(ambient + diffuse + specular) * attenuation // light factors from our single light
		) * inColor * textureColor.rgb; // Object colo		
	}
	//ambient, specular, and custom
	if(u_allcustom)
	{
		result = ((u_AmbientCol * u_AmbientStrength) + // global ambient light
		(ambient + diffuse + specular) * attenuation // light factors from our single light
		) * inColor * textureColor.rgb +// Object colo	 
		(diffuseOut * edge); 

	}

	/*vec3 result = (
		(u_AmbientCol * u_AmbientStrength) + // global ambient light
		(ambient + diffuse + specular) * attenuation // light factors from our single light
		) * inColor * textureColor.rgb; // Object color*/

	frag_color = vec4(result, textureColor.a);
}