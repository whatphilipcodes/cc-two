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
    // The pipeline sets use_camera_wb = 1, so camera WB will be used as base
    // We can modify the user_mul to adjust from there if needed
    // For now, we'll let camera WB handle it unless we want to override

    // If user wants to override with specific temperature, set user multipliers
    // Otherwise, just use camera WB

    // Optionally: Apply white balance adjustment based on color temperature
    // Clamp temperature to reasonable range
    float temp_k = std::max(2000.0f, std::min(12000.0f, temperature));

    // Use daylight (5500K) as reference
    float reference_temp = 5500.0f;

    // Only apply custom WB if significantly different from reference
    if (std::abs(temp_k - reference_temp) > 100.0f)
    {
        float red_mul, green_mul, blue_mul;

        if (temp_k < reference_temp)
        {
            // Cooler than daylight - increase blue, decrease red
            float cool_factor = (reference_temp - temp_k) / (reference_temp - 2000.0f);
            red_mul = 1.0f - cool_factor * 0.4f;
            green_mul = 1.0f;
            blue_mul = 1.0f + cool_factor * 0.6f;
        }
        else
        {
            // Warmer than daylight - increase red, decrease blue
            float warm_factor = (temp_k - reference_temp) / (12000.0f - reference_temp);
            red_mul = 1.0f + warm_factor * 0.6f;
            green_mul = 1.0f;
            blue_mul = 1.0f - warm_factor * 0.4f;
        }

        // Set the white balance multipliers
        processor.imgdata.params.user_mul[0] = red_mul;
        processor.imgdata.params.user_mul[1] = green_mul;
        processor.imgdata.params.user_mul[2] = blue_mul;
        processor.imgdata.params.user_mul[3] = green_mul;

        // Override camera WB with our custom values
        processor.imgdata.params.use_camera_wb = 0;
        processor.imgdata.params.use_auto_wb = 0;
    }
    // else: use camera WB (already set in pipeline)
}