#version 410

layout(location = 0) in vec3 inPos;
layout(location = 1) in vec3 inColor;
layout(location = 2) in vec3 inNormal;
layout(location = 3) in vec2 inUV;

uniform sampler2D s_Diffuse;
uniform sampler2D s_Diffuse2;
uniform vec3  u_AmbientCol;
uniform float u_AmbientStrength;

uniform vec3 eye_pos;

uniform vec3  u_LightPos;
uniform vec3  u_LightCol;
uniform float u_AmbientLightStrength;
uniform float u_SpecularLightStrength;
uniform float u_Shininess; 

uniform float u_TextureMix;

uniform vec3  u_CamPos;

out vec4 frag_color;

uniform bool u_ambientToggle;
uniform bool u_specularToggle; 
uniform bool u_off; 
uniform bool u_ambientspecular; 
uniform bool u_allcustom; 

const float lightIntensity = 10.0;

//Toon shading
const int bands = 5;
const float scaleFactor = 1.0/bands;

// https://learnopengl.com/Advanced-Lighting/Advanced-Lighting
void main() 
{
	vec3 L = normalize(u_LightPos - inPos);
	vec3 V = normalize(eye_pos - inPos);

	vec3 ambient = vec3(0, 0, 0);
	vec3 specular = vec3(0, 0, 0);


	// diffuse setup
	vec3 N = normalize(inNormal);
	vec3 lightDir = normalize(u_LightPos - inPos);

	float dif = max(dot(N, lightDir), 0.0);

	// Specular setup
	vec3 viewDir  = normalize(u_CamPos - inPos);
	vec3 h        = normalize(lightDir + viewDir);
	float spec	  = pow(max(dot(N, h), 0.0), u_Shininess); // Shininess coefficient (can be a uniform)

	// diffuse
	vec3 diffuse = dif * u_LightCol;

	vec3 diffuseOut = vec3(0, 0, 0); 
	float dist = length(u_LightPos - inPos);

	//texture
	vec4 textureColor1 = texture(s_Diffuse, inUV);
	vec4 textureColor2 = texture(s_Diffuse2, inUV);
	vec4 textureColor = mix(textureColor1, textureColor2, u_TextureMix);


	//result
	vec3 result = (ambient + diffuse + specular) * inColor * textureColor.rgb;
	

	if (u_ambientToggle == true)
	{
		// ambient
		ambient = ((u_AmbientStrength * u_LightCol) + (u_AmbientCol * u_AmbientStrength));
		specular = vec3(0);
	}
	else
	{
		ambient = vec3(0);
		specular = u_SpecularLightStrength * spec * u_LightCol; 
	}




	if (u_specularToggle == true)
	{
		// specular
		specular = u_SpecularLightStrength * spec * u_LightCol; 
		ambient = vec3(0);
	}
	else
	{
		specular = vec3(0);
		ambient = ((u_AmbientStrength * u_LightCol) + (u_AmbientCol * u_AmbientStrength));
	}	

	
	//no light
	if (u_off == true)
	{
		ambient = vec3(0);
		diffuse = vec3(0);	
		specular = vec3(0);
	}


	//ambient + specular
	if (u_ambientspecular == true)
	{
		ambient = ((u_AmbientLightStrength * u_LightCol) + (u_AmbientCol * u_AmbientStrength));
		specular = u_SpecularLightStrength * spec * u_LightCol; 		
	}
	else
	{
		ambient = vec3(0);
		specular = vec3(0);
	}


	//ambient + specular + toonshader
	if(u_allcustom == true)
	{
		ambient = ((u_AmbientLightStrength * u_LightCol) + (u_AmbientCol * u_AmbientStrength));
		specular = u_SpecularLightStrength * spec * u_LightCol;

		//Toon Shader setup
		dist = length(u_LightPos - inPos);
		diffuseOut = (diffuse * inColor) / (dist*dist);
		diffuseOut = diffuseOut*lightIntensity;
		diffuseOut = floor(diffuseOut * bands) * scaleFactor;

		//Outline effect		
		float edge = (dot(V, inNormal) < 0.4) ? 0.0 : 1.0;
		vec3 result = diffuseOut * edge;
	}
	else
	{
		vec3 result = (ambient + diffuse + specular) * inColor;
	}



	frag_color = vec4(result, 1.0);
}