#pragma once

#include "IAdjustment.h"

class ExposureAdjustment : public IAdjustment
{
public:
    ExposureAdjustment(float stops);
    void apply(LibRaw &iProcessor) override;

private:
    float exposure_stops;
};