#pragma once

#include "Graphics/Post/PostEffect.h"

class BlurEffect : public PostEffect
{
public:
	//Initializes framebuffer
	void Init(unsigned width, unsigned height) override;

	//Applies effect to this buffer
	void ApplyEffect(PostEffect* buffer) override;

	//Getters
	float GetRadius() const;
	float GetResolution() const;

	//Setters
	void SetRadius(float radius);
	void SetResolution(float resolution);

private:
	float _radius = 1.0f;
	float _resolution = 1.0f;
};