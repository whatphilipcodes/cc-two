#include "Adjustments/WhiteBalanceAdjustment.h"
#include <cmath>
#include <algorithm>

WhiteBalanceAdjustment::WhiteBalanceAdjustment(float kelvin) : temperature(kelvin) {}

void WhiteBalanceAdjustment::setParameter(float value)
{
    this->temperature = value;
}
float WhiteBalanceAdjustment::getParameter() const { return temperature; }

void WhiteBalanceAdjustment::apply(LibRaw &processor)
{
    // Apply white balance adjustment based on color temperature
    // Clamp temperature to reasonable range
    float temp_k = std::max(2000.0f, std::min(12000.0f, temperature));

    // Use daylight (5500K) as reference
    float reference_temp = 5500.0f;

    float red_mul, green_mul, blue_mul;

    if (temp_k < reference_temp)
    {
        // Cooler than daylight - increase blue, decrease red
        float cool_factor = (reference_temp - temp_k) / (reference_temp - 2000.0f); // 0 to 1
        red_mul = 1.0f - cool_factor * 0.4f;                                        // Reduce red for cooler tones
        green_mul = 1.0f;                                                           // Keep green neutral
        blue_mul = 1.0f + cool_factor * 0.6f;                                       // Increase blue for cooler tones
    }
    else
    {
        // Warmer than daylight - increase red, decrease blue
        float warm_factor = (temp_k - reference_temp) / (12000.0f - reference_temp); // 0 to 1
        red_mul = 1.0f + warm_factor * 0.6f;                                         // Increase red for warmer tones
        green_mul = 1.0f;                                                            // Keep green neutral
        blue_mul = 1.0f - warm_factor * 0.4f;                                        // Reduce blue for warmer tones
    }

    // Set the white balance multipliers
    processor.imgdata.params.user_mul[0] = red_mul;
    processor.imgdata.params.user_mul[1] = green_mul;
    processor.imgdata.params.user_mul[2] = blue_mul;
    processor.imgdata.params.user_mul[3] = green_mul;

    // Disable auto white balance since we're setting it manually
    processor.imgdata.params.use_auto_wb = 0;
    processor.imgdata.params.use_camera_wb = 0;
}