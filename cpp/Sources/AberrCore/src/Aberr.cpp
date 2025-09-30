#include "Aberr.h"
#include <libraw/libraw.h>
#include <iostream>
#include <cstring>

// Implement the custom deleter
void LibRawDeleter::operator()(LibRaw *ptr) const
{
    delete ptr;
}

Aberr::Aberr() : libraw_processor(nullptr), image_loaded(false), color_temperature(5500.0f), original_color_temperature(5500.0f)
{
    // Initialize all members to safe defaults
}

Aberr::~Aberr()
{
    // Destructor - unique_ptr will handle cleanup automatically
}

std::string Aberr::getLibRawVersion() const
{
    return std::string(LibRaw::version());
}

bool Aberr::loadRawImage(const char *filepath)
{
    // Reset any previous state
    libraw_processor.reset();

    libraw_processor = std::unique_ptr<LibRaw, LibRawDeleter>(new LibRaw());

    std::cout << "Loading raw image: " << filepath << std::endl;

    int ret = libraw_processor->open_file(filepath);
    if (ret != LIBRAW_SUCCESS)
    {
        last_error = "Failed to open file: " + std::string(libraw_strerror(ret));
        libraw_processor.reset();
        return false;
    }

    ret = libraw_processor->unpack();
    if (ret != LIBRAW_SUCCESS)
    {
        last_error = "Failed to unpack image: " + std::string(libraw_strerror(ret));
        libraw_processor.reset();
        return false;
    }

    image_loaded = true;

    // Get current white balance settings
    if (libraw_processor->imgdata.color.cam_mul[0] > 0)
    {
        // Estimate color temperature from camera multipliers
        // This is a rough approximation
        float red_mul = libraw_processor->imgdata.color.cam_mul[0];
        float blue_mul = libraw_processor->imgdata.color.cam_mul[2];
        if (blue_mul > 0)
        {
            float ratio = red_mul / blue_mul;
            // Very rough temperature estimation (this could be improved)
            color_temperature = 2000.0f + (ratio - 0.5f) * 4000.0f;
            if (color_temperature < 2000.0f)
                color_temperature = 2000.0f;
            if (color_temperature > 10000.0f)
                color_temperature = 10000.0f;
        }
        else
        {
            color_temperature = 5500.0f; // Default daylight
        }
    }
    else
    {
        color_temperature = 5500.0f; // Default daylight
    }

    // Store the original estimated temperature
    original_color_temperature = color_temperature;

    std::cout << "Image loaded successfully. Estimated color temperature: " << color_temperature << "K" << std::endl;
    return true;
}

float Aberr::getCurrentColorTemperature() const
{
    return color_temperature;
}

void Aberr::setColorTemperature(float temperature)
{
    if (!image_loaded || !libraw_processor)
    {
        last_error = "No image loaded";
        return;
    }

    color_temperature = temperature;

    // Get the original camera multipliers as baseline
    float orig_red = libraw_processor->imgdata.color.cam_mul[0];
    float orig_green = libraw_processor->imgdata.color.cam_mul[1];
    float orig_blue = libraw_processor->imgdata.color.cam_mul[2];

    std::cout << "Camera multipliers - R:" << orig_red << " G:" << orig_green << " B:" << orig_blue << std::endl;

    // Check if we should use camera white balance (when temp is close to original estimated)
    float temp_diff = std::abs(temperature - original_color_temperature);
    std::cout << "Temperature difference from original: " << temp_diff << "K" << std::endl;

    if (temp_diff < 50.0f)
    {
        // Use camera white balance - set all user multipliers to 0 to indicate "use camera WB"
        libraw_processor->imgdata.params.user_mul[0] = 0;
        libraw_processor->imgdata.params.user_mul[1] = 0;
        libraw_processor->imgdata.params.user_mul[2] = 0;
        libraw_processor->imgdata.params.user_mul[3] = 0;

        std::cout << "Using camera white balance (temperature close to original)" << std::endl;
        color_temperature = temperature; // Update the current temperature
        return;
    }

    // If camera multipliers are not available, use daylight defaults
    if (orig_red <= 0 || orig_green <= 0 || orig_blue <= 0)
    {
        orig_red = 2.0f;
        orig_green = 1.0f;
        orig_blue = 1.5f;
        std::cout << "Using default multipliers" << std::endl;
    }

    // Normalize to green
    float norm_red = orig_red / orig_green;
    float norm_blue = orig_blue / orig_green;

    // Apply color temperature adjustment
    // Use the original estimated temperature as reference
    float temp_ratio = temperature / original_color_temperature;

    float red_mul, green_mul, blue_mul;

    if (temp_ratio < 1.0f)
    {
        // Making warmer - increase red, reduce blue
        red_mul = norm_red * (1.0f + (1.0f - temp_ratio) * 0.5f);
        green_mul = 1.0f;
        blue_mul = norm_blue * temp_ratio;
    }
    else
    {
        // Making cooler - reduce red, increase blue
        red_mul = norm_red / temp_ratio;
        green_mul = 1.0f;
        blue_mul = norm_blue * (1.0f + (temp_ratio - 1.0f) * 0.5f);
    }

    // Set the white balance multipliers using LibRaw parameters
    libraw_processor->imgdata.params.user_mul[0] = red_mul;
    libraw_processor->imgdata.params.user_mul[1] = green_mul;
    libraw_processor->imgdata.params.user_mul[2] = blue_mul;
    libraw_processor->imgdata.params.user_mul[3] = green_mul;

    // Update the current color temperature
    color_temperature = temperature;

    std::cout << "Color temperature set to " << temperature << "K (from " << original_color_temperature << "K)" << std::endl;
    std::cout << "Normalized camera multipliers - R:" << norm_red << " G:1.0 B:" << norm_blue << std::endl;
    std::cout << "New multipliers - R:" << red_mul << " G:" << green_mul << " B:" << blue_mul << std::endl;
}

bool Aberr::processAndSave(const char *outputPath)
{
    if (!image_loaded || !libraw_processor)
    {
        last_error = "No image loaded";
        return false;
    }

    std::cout << "Processing image..." << std::endl;

    // Check if we should use camera white balance (user_mul all zero means use camera WB)
    bool use_camera_wb = (libraw_processor->imgdata.params.user_mul[0] == 0 &&
                          libraw_processor->imgdata.params.user_mul[1] == 0 &&
                          libraw_processor->imgdata.params.user_mul[2] == 0 &&
                          libraw_processor->imgdata.params.user_mul[3] == 0);

    // Set output parameters
    libraw_processor->imgdata.params.output_bps = 8;                        // 8-bit output
    libraw_processor->imgdata.params.output_tiff = 0;                       // PPM output by default
    libraw_processor->imgdata.params.use_camera_wb = use_camera_wb ? 1 : 0; // Use camera WB if requested
    libraw_processor->imgdata.params.use_auto_wb = 0;                       // Don't use auto white balance
    libraw_processor->imgdata.params.user_flip = 0;
    libraw_processor->imgdata.params.bright = 1.0;       // Brightness multiplier
    libraw_processor->imgdata.params.four_color_rgb = 0; // Use 3-color RGB
    libraw_processor->imgdata.params.highlight = 0;      // No highlight recovery
    libraw_processor->imgdata.params.no_auto_bright = 1; // Disable auto brightness

    // Process the image
    int ret = libraw_processor->dcraw_process();
    if (ret != LIBRAW_SUCCESS)
    {
        last_error = "Failed to process image: " + std::string(libraw_strerror(ret));
        return false;
    }

    // Write to file
    ret = libraw_processor->dcraw_ppm_tiff_writer(outputPath);
    if (ret != LIBRAW_SUCCESS)
    {
        last_error = "Failed to write output file: " + std::string(libraw_strerror(ret));
        return false;
    }

    std::cout << "Image saved to: " << outputPath << std::endl;

    // Clean up processed data to prevent double-free issues
    libraw_processor->recycle_datastream();

    return true;
}

std::string Aberr::getLastError() const
{
    return last_error;
}