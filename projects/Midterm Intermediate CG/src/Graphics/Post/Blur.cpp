#include "Blur.h"

void BlurEffect::Init(unsigned width, unsigned height)
{
    int index = int(_buffers.size());
    _buffers.push_back(new Framebuffer());
    _buffers[index]->AddColorTarget(GL_RGBA8);
    _buffers[index]->AddDepthTarget();
    _buffers[index]->Init(width, height);

    //Set up shaders
    index = int(_shaders.size());
    _shaders.push_back(Shader::Create());
    _shaders[index]->LoadShaderPartFromFile("shaders/passthrough_vert.glsl", GL_VERTEX_SHADER);
    _shaders[index]->LoadShaderPartFromFile("shaders/Post/blur_frag.glsl", GL_FRAGMENT_SHADER);
    _shaders[index]->Link();
}

void BlurEffect::ApplyEffect(PostEffect* buffer)
{
    BindShader(0);
    _shaders[0]->SetUniform("u_radius", _radius);
    _shaders[0]->SetUniform("u_resolution", _radius);

    buffer->BindColorAsTexture(0, 0, 0);

    _buffers[0]->RenderToFSQ();

    buffer->UnbindTexture(0);

    UnbindShader();
}

float BlurEffect::GetRadius() const
{
    return _radius;
}

float BlurEffect::GetResolution() const
{
    return _resolution;
}

void BlurEffect::SetRadius(float radius)
{
    _radius = radius;
}

void BlurEffect::SetResolution(float resolution)
{
    _resolution = resolution;
}
