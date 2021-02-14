#include "Bloom.h"

void BloomEffect::Init(unsigned width, unsigned height)
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
    _shaders[index]->LoadShaderPartFromFile("shaders/Post/bloom_frag.glsl", GL_FRAGMENT_SHADER);
    _shaders[index]->Link();
}

void BloomEffect::ApplyEffect(PostEffect* buffer)
{
    BindShader(0);
    _shaders[0]->SetUniform("u_strength", _strength);

    buffer->BindColorAsTexture(0, 0, 0);

    _buffers[0]->RenderToFSQ();

    buffer->UnbindTexture(0);

    UnbindShader();
}

float BloomEffect::GetStrength() const
{
    return _strength;
}

float BloomEffect::GetRadius() const
{
    return _radius;
}

float BloomEffect::GetResolution() const
{
    return _resolution;
}

void BloomEffect::SetStrength(float strength)
{
    _strength = strength;
}

void BloomEffect::SetRadius(float radius)
{
    _radius = radius;
}

void BloomEffect::SetResolution(float resolution)
{
    _resolution = resolution;
}
