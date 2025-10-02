#include "Aberr.h"
#include <libraw/libraw.h>

Aberr::Aberr()
{
    // make_unique has to be declared on individual lines: https://learn.microsoft.com/en-us/cpp/cpp/smart-pointers-modern-cpp
    processor = std::make_unique<LibRaw>();
    pipeline = std::make_unique<DevelopmentPipeline>();
}

std::string Aberr::getLibRawVersion() const
{
    return std::string(processor->version());
}

void Aberr::loadImage(char *image)
{
    this->reset();
    processor->open_file(image);
    processor->unpack();
}

void Aberr::getImage() {}

void Aberr::preview() {}

void Aberr::render() {}

void Aberr::reset()
{
    processor->recycle();
}