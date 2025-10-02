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
    void loadImage(char *image);
    void getImage();
    void preview();
    void render();

private:
    void reset();
    std::unique_ptr<LibRaw> processor;
    std::unique_ptr<DevelopmentPipeline> pipeline;
};