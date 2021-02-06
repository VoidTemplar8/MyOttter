#include "ColorCorrectionPostEffect.h"

void ColorCorrectionEffect::Init(unsigned width, unsigned height)
{
    int index = int(_buffers.size());
    _buffers.push_back(new Framebuffer());
    _buffers[index]->AddColorTarget(GL_RGBA8);
    _buffers[index]->Init(width, height);

    _lut.loadFromFile("cubes/Lut_test.cube");
    //Loads the shaders
    index = int(_shaders.size());
    _shaders.push_back(Shader::Create());
    _shaders[index]->LoadShaderPartFromFile("shaders/passthrough_vert.glsl", GL_VERTEX_SHADER);
    _shaders[index]->LoadShaderPartFromFile("shaders/Post/color_correction_frag.glsl", GL_FRAGMENT_SHADER);
    _shaders[index]->Link();

    PostEffect::Init(width, height);
}

void ColorCorrectionEffect::ApplyEffect(PostEffect* buffer)
{
    BindShader(0);

    buffer->BindColorAsTexture(0, 0, 0);

    _lut.bind(30);

    _buffers[0]->RenderToFSQ();

    _lut.unbind(1);

    UnbindShader();
}

void ColorCorrectionEffect::LUTLoad(std::string path)
{
    LUT3D temp(path);
    _lut = temp;
}


