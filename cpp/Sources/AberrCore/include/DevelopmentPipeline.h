#pragma once

#include <vector>
#include <memory>
#include "libraw/libraw.h"

#include "IAdjustment.h"

class DevelopmentPipeline
{
public:
    void addAdjustment(std::unique_ptr<IAdjustment> adjustment);
    void process(LibRaw &iProcessor);

private:
    std::vector<std::unique_ptr<IAdjustment>> adjustments;
};