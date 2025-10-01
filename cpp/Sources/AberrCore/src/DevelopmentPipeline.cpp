#include "DevelopmentPipeline.h"

void DevelopmentPipeline::addAdjustment(std::shared_ptr<IAdjustment> adjustment)
{
    adjustments.push_back(adjustment);
}

void DevelopmentPipeline::process(LibRaw &iProcessor)
{
    for (const auto &adjustment : adjustments)
    {
        if (adjustment)
        {
            adjustment->apply(iProcessor);
        }
    }
}