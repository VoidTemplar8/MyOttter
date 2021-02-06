#pragma once

#include "Graphics/Post/PostEffect.h"
#include "Graphics/LUT.h"

class ColorCorrectionEffect : public PostEffect
{
public:
	//Initializes framebuffer
	//Overrides post effect Init
	void Init(unsigned width, unsigned height) override;

	//Applies the effect to this buffer
	//passes the previous framebuffer witrh the texture to apply as parameter
	void ApplyEffect(PostEffect* buffer) override;

	//Applies the effect to the screen
	//void DrawToScreen() override;

	//Load in Lut
	void LUTLoad(std::string path);

private:
	LUT3D _lut;
};