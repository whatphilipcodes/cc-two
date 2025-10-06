#pragma once

#include <vector>
#include <memory>
#include "libraw/libraw.h"

#include "IAdjustment.h"
#include "ProcessingTypes.h"
#include "Adjustments/ExposureAdjustment.h"
#include "Adjustments/WhiteBalanceAdjustment.h"

class DevelopmentPipeline
{
public:
    void process(LibRaw &processor, ProcessingQuality quality);
    ExposureAdjustment exp = ExposureAdjustment(0.0f);
    WhiteBalanceAdjustment wb = WhiteBalanceAdjustment(5500.0f);

private:
};