#pragma once

#include <string>
#include <memory>
#include "libraw/libraw.h"

#include "DevelopmentPipeline.h"
#include "ProcessingTypes.h"

class Aberr
{
public:
    Aberr();
    std::string getLibRawVersion() const;
    void loadImageFromFile(char *image);
    void loadImageFromBuffer(const void *buffer, size_t size);
    void getImage();
    void updateAdjustment(AdjustmentType type, float value);
    void preview();
    void render();

private:
    void reset();
    std::unique_ptr<LibRaw> processor;
    std::unique_ptr<DevelopmentPipeline> pipeline;
};