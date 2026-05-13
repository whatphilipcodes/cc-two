#include "DevelopmentPipeline.h"
#include <stdexcept>
#include <string>

void DevelopmentPipeline::process(LibRaw &processor, ProcessingQuality quality)
{
    // Configure output parameters for proper image output
    processor.imgdata.params.output_bps = 8;      // 8-bit output for now
    processor.imgdata.params.output_color = 1;    // sRGB color space
    processor.imgdata.params.gamm[0] = 1.0 / 2.4; // sRGB gamma curve
    processor.imgdata.params.gamm[1] = 12.92;     // sRGB gamma curve
    processor.imgdata.params.no_auto_bright = 0;  // Enable auto brightness
    processor.imgdata.params.use_camera_wb = 1;   // Use camera WB as base

    // Apply adjustments
    exp.apply(processor);
    wb.apply(processor);

    // Actually process the RAW data with all settings
    int ret = processor.dcraw_process();
    if (ret != LIBRAW_SUCCESS)
    {
        throw std::runtime_error(std::string("dcraw_process failed: ") + libraw_strerror(ret));
    }
}