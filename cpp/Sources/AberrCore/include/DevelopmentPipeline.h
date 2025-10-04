#pragma once

#include <vector>
#include <memory>
#include "libraw/libraw.h"

#include "IAdjustment.h"
#include "Adjustments/ExposureAdjustment.h"
#include "Adjustments/WhiteBalanceAdjustment.h"

class DevelopmentPipeline
{
public:
    // DevelopmentPipeline();
    void process(LibRaw &processor);
    ExposureAdjustment exp = ExposureAdjustment(0.0f);
    WhiteBalanceAdjustment wb = WhiteBalanceAdjustment(5500.0f);

private:
};