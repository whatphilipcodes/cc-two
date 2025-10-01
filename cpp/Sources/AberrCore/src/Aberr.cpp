#include "Aberr.h"
#include <libraw/libraw.h>

Aberr::Aberr()
{ // make_unique has to be declared on individual lines: https://learn.microsoft.com/en-us/cpp/cpp/smart-pointers-modern-cpp?view=msvc-170
    processor = std::make_unique<LibRaw>();
    pipeline = std::make_unique<DevelopmentPipeline>();
}

std::string Aberr::getLibRawVersion() const
{
    return std::string(processor->version());
}