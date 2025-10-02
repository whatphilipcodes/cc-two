#include "Adjustments/ExposureAdjustment.h"
#include <cmath>
#include <algorithm>

ExposureAdjustment::ExposureAdjustment(float stops) : exposure_stops(stops) {}

void ExposureAdjustment::apply(LibRaw &iProcessor)
{
    // Apply exposure adjustment
    // LibRaw uses a brightness multiplier, where 1.0 = no change
    // Each stop is a factor of 2, so stops to multiplier: 2^stops
    float multiplier = std::pow(2.0f, exposure_stops);

    // Clamp to reasonable range to avoid extreme values
    multiplier = std::max(0.1f, std::min(multiplier, 10.0f));

    iProcessor.imgdata.params.bright = multiplier;
}