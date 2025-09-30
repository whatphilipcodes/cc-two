#pragma once

#include <string>
#include <memory>

// Forward declare LibRaw to avoid including it in header
class LibRaw;

// Custom deleter for LibRaw (forward declared type)
struct LibRawDeleter
{
    void operator()(LibRaw *ptr) const;
};

class Aberr
{
public:
    // Constructor
    Aberr();

    // Destructor
    ~Aberr();

    // Delete copy constructor and assignment (non-copyable)
    Aberr(const Aberr &) = delete;
    Aberr &operator=(const Aberr &) = delete;

    // Move constructor and assignment
    Aberr(Aberr &&) = default;
    Aberr &operator=(Aberr &&) = default;

    // Returns the LibRaw version info as std::string.
    std::string getLibRawVersion() const;

    // Load a raw image from file path
    bool loadRawImage(const char *filepath);

    // Get current color temperature from the loaded image
    float getCurrentColorTemperature() const;

    // Set color temperature for processing
    void setColorTemperature(float temperature);

    // Process the image and save to output path
    bool processAndSave(const char *outputPath);

    // Get error message if any operation fails
    std::string getLastError() const;

private:
    std::unique_ptr<LibRaw, LibRawDeleter> libraw_processor;
    std::string last_error;
    bool image_loaded;
    float color_temperature;
    float original_color_temperature;
};