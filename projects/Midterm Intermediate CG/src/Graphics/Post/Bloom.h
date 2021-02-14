#pragma once

#include "Graphics/Post/PostEffect.h"

class BloomEffect : public PostEffect
{
public:
	//Initializes framebuffer
	void Init(unsigned width, unsigned height) override;

	//Applies effect to this buffer
	void ApplyEffect(PostEffect* buffer) override;

	//Getters
	float GetStrength() const;
	float GetRadius() const;
	float GetResolution() const;

	//Setters
	void SetStrength(float strength);
	void SetRadius(float radius);
	void SetResolution(float resolution);

private:
	float _strength = 0.5f;
	float _radius = 1.0f;
	float _resolution = 1.0f;
}; 
