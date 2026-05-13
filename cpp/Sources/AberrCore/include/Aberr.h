#pragma once

#include <string>
#include <memory>
#include <vector>
#include "libraw/libraw.h"

#include "DevelopmentPipeline.h"
#include "ProcessingTypes.h"

// Simple struct with no pointers - safe for Swift
struct ProcessedImageInfo
{
    unsigned int width;
    unsigned int height;
    unsigned int bits;
    unsigned int colors;
};

class Aberr
{
public:
    Aberr();
    std::string getLibRawVersion() const;
    void loadImageFromFile(char *image);
    void loadImageFromBuffer(const void *buffer, size_t size);

    // Get image data as vector - safe for Swift interop
    std::vector<unsigned char> getProcessedImageBytes(ProcessedImageInfo &info);

    void updateAdjustment(AdjustmentType type, float value);
    void preview();
    void render();

private:
    void reset();
    std::unique_ptr<LibRaw> processor;
    std::unique_ptr<DevelopmentPipeline> pipeline;
};