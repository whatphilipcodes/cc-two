#pragma once

#include <vector>
#include <memory>
#include "libraw/libraw.h"
#include "IAdjustment.h"

class DevelopmentPipeline
{
public:
    DevelopmentPipeline() = default;
    void addAdjustment(std::shared_ptr<IAdjustment> adjustment);
    void process(LibRaw &iProcessor);

private:
    std::vector<std::shared_ptr<IAdjustment>> adjustments;
};