#include "Aberr.h"
// #include <libraw/libraw.h>

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

// load image that is handed through from app ui
void Aberr::loadImageFromFile(char *image)
{
    this->reset();
    processor->open_file(image);
    processor->unpack();
    processor->raw2image(); // for edits with pure sensor data add preprocessing step before this
}

// PhotoKit (iOS ui) provides a buffer not a filepath
void Aberr::loadImageFromBuffer(const void *buffer, size_t size)
{
    this->reset();
    int ret = processor->open_buffer(buffer, size);
    if (ret != LIBRAW_SUCCESS)
    {
        throw std::runtime_error("updateAdjustment(): Unknown adjustment type");
    }
    processor->unpack();
    processor->raw2image();
}

// scope guard pattern: "loan" function -> see AberrCoreWrapper.swift
void Aberr::withProcessedImage(ImageCallback *callback, void *context)
{
    if (!callback)
    {
        return;
    }

    int ret = 0;
    libraw_processed_image_t *image = processor->dcraw_make_mem_image(&ret);

    if (image)
    {
        callback(image, context);
        LibRaw::dcraw_clear_mem(image);
    }
    else
    {
        callback(nullptr, context);
    }
}

// pass in ui changes
void Aberr::updateAdjustment(AdjustmentType type, float value)
{
    switch (type)
    {
    case AdjustmentType::Exposure:
        pipeline->exp.setParameter(value);
        break;
    case AdjustmentType::WhiteBalance:
        pipeline->wb.setParameter(value);
        break;
    default:
        throw std::runtime_error("updateAdjustment(): Unknown adjustment type");
    }
}

// realtime render pass
void Aberr::preview()
{
    pipeline->process(*processor, ProcessingQuality::Preview);
}

// final image rendering pass for export
void Aberr::render()
{
    pipeline->process(*processor, ProcessingQuality::Render);
}

// internal reset utility to clear for new image
void Aberr::reset()
{
    processor->recycle();
}