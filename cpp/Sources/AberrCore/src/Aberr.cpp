#include "Aberr.h"
#include <iostream>

// internal error checking utility
static void check_libraw_error(int ret, const char *operation)
{
    if (ret != LIBRAW_SUCCESS)
    {
        std::string error_msg = std::string(operation) + ": " + libraw_strerror(ret);
        std::cerr << "[LibRaw Error] " << error_msg << std::endl;
        throw std::runtime_error(error_msg);
    }
}

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
    check_libraw_error(processor->open_file(image), "open_file");
    check_libraw_error(processor->unpack(), "unpack");
    check_libraw_error(processor->raw2image(), "raw2image");
}

// PhotoKit (iOS ui) provides a buffer not a filepath
void Aberr::loadImageFromBuffer(const void *buffer, size_t size)
{
    this->reset();
    check_libraw_error(processor->open_buffer(buffer, size), "open_buffer");
    check_libraw_error(processor->unpack(), "unpack");
    check_libraw_error(processor->raw2image(), "raw2image");
}

// Get processed image data - copies data into vector for safe Swift interop
std::vector<unsigned char> Aberr::getProcessedImageBytes(ProcessedImageInfo &info)
{
    int ret = 0;
    libraw_processed_image_t *image = processor->dcraw_make_mem_image(&ret);
    check_libraw_error(ret, "dcraw_make_mem_image");

    if (!image)
    {
        throw std::runtime_error("Failed to create processed image");
    }

    // Fill in image info
    info.width = image->width;
    info.height = image->height;
    info.bits = image->bits;
    info.colors = image->colors;

    // Copy data into vector
    std::vector<unsigned char> result(image->data, image->data + image->data_size);

    // Clean up LibRaw memory
    LibRaw::dcraw_clear_mem(image);

    return result;
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