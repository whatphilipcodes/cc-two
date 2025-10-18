#pragma once

#include <string>
#include <memory>
#include "libraw/libraw.h"

#include "DevelopmentPipeline.h"
#include "ProcessingTypes.h"

// cb def as C-Style fn for interop: https://github.com/swiftlang/swift/issues/77388
using ImageCallback = void(const libraw_processed_image_t *image, void *context);

class Aberr
{
public:
    Aberr();
    std::string getLibRawVersion() const;
    void loadImageFromFile(char *image);
    void loadImageFromBuffer(const void *buffer, size_t size);
    void withProcessedImage(ImageCallback *callback, void *context);
    void updateAdjustment(AdjustmentType type, float value);
    void preview();
    void render();

private:
    void reset();
    std::unique_ptr<LibRaw> processor;
    std::unique_ptr<DevelopmentPipeline> pipeline;
};