#include "DevelopmentPipeline.h"

struct DevelopmentPipeline::Impl
{
    std::vector<std::unique_ptr<IAdjustment>> adjustments;
};

DevelopmentPipeline::DevelopmentPipeline() : pimpl(std::make_unique<Impl>()) {}

// generating defaults that were disabled due to pimpl
DevelopmentPipeline::~DevelopmentPipeline() = default;
DevelopmentPipeline::DevelopmentPipeline(DevelopmentPipeline &&) noexcept = default;
DevelopmentPipeline &DevelopmentPipeline::operator=(DevelopmentPipeline &&) noexcept = default;

void DevelopmentPipeline::addAdjustment(std::unique_ptr<IAdjustment> adjustment)
{
    pimpl->adjustments.push_back(std::move(adjustment));
}

void DevelopmentPipeline::process(LibRaw &iProcessor)
{
    for (const auto &adjustment : pimpl->adjustments)
    {
        if (adjustment)
        {
            adjustment->apply(iProcessor);
        }
    }
}