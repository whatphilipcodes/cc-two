#pragma once

#include <string>
#include <memory>
#include "libraw/libraw.h"

#include "DevelopmentPipeline.h"

class Aberr
{
public:
    Aberr();
    std::string getLibRawVersion() const;

private:
    std::unique_ptr<LibRaw> processor;
    std::unique_ptr<DevelopmentPipeline> pipeline;
};